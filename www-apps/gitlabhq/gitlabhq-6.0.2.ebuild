# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# Mainteiner notes:
# - This ebuild uses Bundler to download and install all gems in deployment mode
#   (i.e. into isolated directory inside application). That's not Gentoo way how
#   it should be done, but GitLab has too many dependencies that it will be too
#   difficult to maintain them via ebuilds.
#

USE_RUBY="ruby19 ruby20"
PYTHON_DEPEND="2:2.7"

inherit eutils python ruby-ng

DESCRIPTION="GitLab is a free project and repository management application"
HOMEPAGE="https://github.com/gitlabhq/gitlabhq"
SRC_URI="https://github.com/gitlabhq/gitlabhq/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE="mysql +postgres +unicorn"

## Gems dependencies:
#   charlock_holmes		dev-libs/icu
#	grape, capybara		dev-libs/libxml2, dev-libs/libxslt
#   json				dev-util/ragel
#   pygments.rb			python 2.7+
#   execjs				net-libs/nodejs, or any other JS runtime
#   pg					dev-db/postgresql-base
#   mysql				virtual/mysql
#
GEMS_DEPEND="
	dev-libs/icu
	dev-libs/libxml2
	dev-libs/libxslt
	dev-util/ragel
	net-libs/nodejs
	postgres? ( dev-db/postgresql-base )
	mysql? ( virtual/mysql )"
DEPEND="${GEMS_DEPEND}
	>=dev-vcs/gitlab-shell-1.7
	dev-vcs/git"
RDEPEND="${DEPEND}
	dev-db/redis
	virtual/mta"
ruby_add_bdepend "
	virtual/rubygems
	>=dev-ruby/bundler-1.0"

RUBY_PATCHES=(
	"${P}-fix-gemfile.patch"
	"${P}-fix-project-name-regex.patch"
)

MY_NAME="gitlab"
MY_USER="git"    # should be same as in gitlab-shell

DEST_DIR="/opt/${MY_NAME}-${SLOT}"
CONF_DIR="/etc/${MY_NAME}-${SLOT}"
LOGS_DIR="/var/log/${MY_NAME}"
TEMP_DIR="/var/tmp/${MY_NAME}"

# When updating ebuild to newer version, check list of the queues in
# https://github.com/gitlabhq/gitlabhq/blob/${PV}/lib/tasks/sidekiq.rake
SIDEKIQ_QUEUES="post_receive,mailer,system_hook,project_web_hook,gitlab_shell,common,default"

all_ruby_prepare() {

	# fix paths
	local satellites_path="${TEMP_DIR}/repo_satellites"
	local repos_path=/var/lib/git/repositories
	local hooks_path=/usr/share/gitlab-shell/hooks
	sed -i -E \
		-e "/satellites:$/,/\w:$/   s|(\s*path:\s).*|\1${satellites_path}/|" \
		-e "/gitlab_shell:$/,/\w:$/ s|(\s*repos_path:\s).*|\1${repos_path}/|" \
		-e "/gitlab_shell:$/,/\w:$/ s|(\s*hooks_path:\s).*|\1${hooks_path}/|" \
		config/gitlab.yml.example || die "failed to filter gitlab.yml.example"
	
	local run_path=/run/${MY_NAME}
	sed -i -E \
		-e "s|/home/git/gitlab/tmp/(pids\|sockets)|${run_path}|" \
		-e "s|/home/git/gitlab/log|${LOGS_DIR}|" \
		-e "s|/home/git/gitlab|${DEST_DIR}|" \
		config/unicorn.rb.example || die "failed to filter unicorn.rb.example"
	
	sed -i \
		-e "s|/home/git/gitlab/tmp/sockets|${run_path}|" \
		lib/support/nginx/gitlab || die "failed to filter nginx/gitlab"
	
	# modify default database settings for PostgreSQL
	sed -i -E \
		-e 's|(username:).*|\1 gitlab|' \
		-e 's|(password:).*|\1 gitlab|' \
		-e 's|(socket:).*|/run/postgresql/.s.PGSQL.5432|' \
		config/database.yml.postgresql \
		|| die "failed to filter database.yml.postgresql"

	# rename config files
	mv config/gitlab.yml.example config/gitlab.yml
	mv config/unicorn.rb.example config/unicorn.rb

	local dbconf=config/database.yml
	if use postgres && ! use mysql; then
		mv ${dbconf}.postgresql ${dbconf}
		rm ${dbconf}.mysql
	elif use mysql && ! use postgres; then
		mv ${dbconf}.mysql ${dbconf}
		rm ${dbconf}.postgresql
	fi
	
	# remove zzet's stupid migration which expetcs that users are so foolish
	# to run GitLab with PostgreSQL's superuser...
	rm db/migrate/20121009205010_postgres_create_integer_cast.rb

	# remove useless files
	rm -r lib/support/{deploy,init.d}
	use unicorn || rm config/unicorn.rb
}

all_ruby_install() {
	local dest=${DEST_DIR}
	local conf=${CONF_DIR}
	local logs=${LOGS_DIR}
	local temp=${TEMP_DIR}

	# prepare directories
	diropts -m750
	dodir ${logs} ${temp} ${temp}/repo_satellites

	diropts -m755
	dodir ${conf} ${dest}/public/uploads

	dosym ${temp} ${dest}/tmp
	dosym ${logs} ${dest}/log

	# install configs
	insinto ${conf}
	doins -r config/*
	dosym ${conf} ${dest}/config

	echo 'export RAILS_ENV=production' > "${D}/${dest}/.profile"

	# remove needless dirs
	rm -Rf config tmp log

	# install the rest files
	insinto ${dest}
	doins -r ./

	# install logrotate config
	dodir /etc/logrotate.d
	cat > "${D}/etc/logrotate.d/${MY_NAME}" <<-EOF
		${logs}/*.log {
		    missingok
		    delaycompress
		    compress
		    copytruncate
		}
	EOF

	## Install gems via bundler ##

	cd "${D}/${dest}"

	local without="development test aws"
	local flag; for flag in mysql postgres unicorn; do
		without+="$(use $flag || echo ' '$flag)"
	done
	local bundle_args="--deployment ${without:+--without ${without}}"

	einfo "Running bundle install ${bundle_args} ..."
	${RUBY} /usr/bin/bundle install ${bundle_args} || die "bundler failed"

	# clean gems cache
	rm -Rf vendor/bundle/ruby/*/cache

	# fix permissions
	fowners -R ${MY_USER}:${MY_USER} ${dest} ${temp} ${logs}
	fperms +x script/{rails,check}

	## RC script ##

	local rcscript=gitlab-sidekiq.init
	use unicorn && rcscript=gitlab-unicorn-6.init

	cp "${FILESDIR}/${rcscript}" "${T}" || die
	sed -i \
		-e "s|@USER@|${MY_USER}|" \
		-e "s|@SLOT@|${SLOT}|" \
		-e "s|@GITLAB_BASE@|${dest}|" \
		-e "s|@LOGS_DIR@|${logs}|" \
		-e "s|@QUEUES@|${SIDEKIQ_QUEUES}|" \
		"${T}/${rcscript}" \
		|| die "failed to filter ${rcscript}"

	newinitd "${T}/${rcscript}" "${MY_NAME}-${SLOT}"
}

pkg_postinst() {
	elog
	elog "1. Configure your GitLab's settings in ${CONF_DIR}/gitlab.yml."
	elog
	elog "2. Configure your database settings in ${CONF_DIR}/database.yml"
	elog "   for \"production\" environment."
	elog
	elog "3. Then you should create database for your GitLab instance, if you"
	elog "haven't it already."
	elog
	if use postgres; then
        elog   "If you have local PostgreSQL running, just copy&run:"
        elog "      su postgres"
        elog "      psql -c \"CREATE ROLE gitlab PASSWORD 'gitlab' \\"
        elog "          NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\""
        elog "      createdb -E UTF-8 -O gitlab gitlab_production"
		elog "  Note: You should change your password to something more random..."
		elog
	fi
	elog "4. Finally execute the following command to initlize environment:"
	elog "       emerge --config \"=${CATEGORY}/${PF}\""
	elog "   Note: Do not forget to start Redis server first!"
	elog
	elog "If this is an update from previous version, it's HIGHLY recommended"
	elog "to backup your database before running the config phase!"
}

pkg_config() {
	local shell_conf='/etc/gitlab-shell.yml'

	einfo "Checking configuration files"

	if [ ! -r "${CONF_DIR}/database.yml" ]; then
		eerror "Copy ${CONF_DIR}/database.yml.* to"
		eerror "${CONF_DIR}/database.yml and edit this file in order to configure your" 
		eerror "database settings for \"production\" environment."; die
	fi

	# check gitlab-shell configuration
	if [ -r ${shell_conf} ]; then
		local shell_repos_path="$(ryaml ${shell_conf} repos_path)"
		local gitlab_repos_path="$(ryaml ${CONF_DIR}/gitlab.yml \
			production gitlab_shell repos_path)"

		if [ ! "${shell_repos_path}" -ef "${gitlab_repos_path}" ]; then
			eerror "repos_path in ${CONF_DIR}/gitlab.yml and ${shell_conf}"
			eerror "must points to the same location! Fix the repos_path location and"
			eerror "run this again."; die
		fi
	else
		ewarn "GitLab Shell checks skipped, could not find config file at"
		ewarn "${shell_conf}. Make sure that you have gitlab-shell properly"
		ewarn "installed and that repos_path is the same as in GitLab."
	fi

	local email_from="$(ryaml ${CONF_DIR}/gitlab.yml production gitlab email_from)"
	local git_home=$(getent passwd ${MY_USER} | cut -d: -f6)
	
	# configure Git global settings
	if [ ! -e "${git_home}/.gitconfig" ]; then
		einfo "Setting git user"
		su -l ${MY_USER} -c "
			git config --global user.email '${email_from}';
			git config --global user.name 'GitLab'" \
			|| die "failed to setup git name and email"
	fi

	if [ ! -d "${DEST_DIR}/.git" ]; then
		# create dummy git repo as workaround for
		# https://github.com/bundler/bundler/issues/2039
		einfo "Initializing dummy git repository to avoid false errors from bundler"
		su -l ${MY_USER} -c "
			cd ${DEST_DIR}
			git init
			git add README.md
			git commit -m 'Dummy repository'" >/dev/null
	fi

	## Initialize app ##

	local RAILS_ENV="production"
	local RUBY=${RUBY:-ruby20}
	local BUNDLE="${RUBY} /usr/bin/bundle"

	local dbname="$(ryaml ${CONF_DIR}/database.yml production database)"

	local update=
	while [ ! -n "${update}" ] ; do
		echo
		echo "   Is this an update from previous version (fresh install otherwise)? (y/n)"
		read answer
		if [[ ${answer} =~ ^[Yy]([Ee][Ss])?$ ]]; then
			update=true
		elif [[ ${answer} =~ ^[Nn]([Oo])?$ ]]; then
			update=false
		else
			echo "Answer not recognized"
		fi
	done

	if [ ${update} ]; then
		einfo "Migrating database ..."
		exec_rake db:migrate

		einfo "Cleaning old precompiled assets ..."
		exec_rake assets:clean

		einfo "Cleaning cache ..."
		exec_rake cache:clear
	else
		einfo "Initializing database ..."
		exec_rake gitlab:setup
	fi
	
	einfo "Precompiling assests ..."
	exec_rake assets:precompile:all
	
	if [ ${update} ]; then
		ewarn
		ewarn "This configuration script runs only common migration tasks."
		ewarn "Please read guides on"
		ewarn "    https://github.com/gitlabhq/gitlabhq/blob/master/doc/update/"
		ewarn "for any additional migration tasks specific to your previous GitLab"
		ewarn "version."
	fi
}

ryaml() {
	ruby -ryaml -e 'puts ARGV[1..-1].inject(YAML.load(File.read(ARGV[0]))) {|acc, key| acc[key] }' "$@"
}

exec_rake() {
	local command="${BUNDLE} exec rake $@ RAILS_ENV=${RAILS_ENV}"

	echo "   ${command}"
	su -l ${MY_USER} -c "
		export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8
		cd ${DEST_DIR}
		${command}" \
		|| die "failed to run rake $@"
}
