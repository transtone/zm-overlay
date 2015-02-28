# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GENTOO_DEPEND_ON_PERL="no"

inherit eutils perl-module ssl-cert toolchain-funcs user systemd

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://tengine.taobao.org"
SRC_URI="http://${PN}.taobao.org/download/${P}.tar.gz"

LICENSE="BSD-2"

SLOT="0"
KEYWORDS="*"

TENGINE_UPSTREAM="upstream_check upstream_consistent_hash upstream_keepalive
	upstream-rbtree"

TENGINE_UPSTREAM_SHARED="upstream_ip_hash
	upstream_least_conn upstream_session_sticky"

TENGINE_MODULES_STANDARD="auth_basic
	geo gzip proxy
	ssi ssl stub_status
	${TENGINE_UPSTREAM}"

TENGINE_MODULES_STANDARD_SHARED="access autoindex browser charset_filter empty_gif fastcgi footer_filter
	limit_conn limit_req map memcached referer reqstat rewrite scgi split_clients
	trim_filter userid_filter user_agent uwsgi
	${TENGINE_UPSTREAM_SHARED}"

TENGINE_MODULES_OPTIONAL="concat dav degradation gunzip gzip_static
	perl realip spdy"

TENGINE_MODULES_OPTIONAL_SHARED="addition flv geoip image_filter
	lua mp4 random_index secure_link slice tfs sub sysguard xslt"

TENGINE_MODULES_MAIL="imap pop3 smtp"

TENGINE_MODULES_EXTERNAL=""

IUSE="+dso +http +http-cache +pcre +poll +select +syslog
	+aio backtrace debug google_perftools ipv6 jemalloc libatomic luajit pcre-jit rtmp
	rtsig ssl vim-syntax"

for module in $TENGINE_MODULES_STANDARD ; do
	IUSE+=" +tengine_static_modules_http_${module}"
done

for module in $TENGINE_MODULES_STANDARD_SHARED ; do
	IUSE+=" tengine_shared_modules_http_${module} +tengine_static_modules_http_${module}"
done

for module in $TENGINE_MODULES_OPTIONAL ; do
	IUSE+=" +tengine_static_modules_http_${module}"
done

for module in $TENGINE_MODULES_OPTIONAL_SHARED ; do
	IUSE+=" tengine_shared_modules_http_${module} tengine_static_modules_http_${module}"
done

for module in $TENGINE_MODULES_MAIL ; do
	IUSE+=" tengine_modules_mail_${module}"
done

for module in $TENGINE_MODULES_EXTERNAL ; do
	IUSE+=" tengine_external_modules_http_${module}"
done

RDEPEND="http-cache? ( dev-libs/openssl )
	jemalloc? ( dev-libs/jemalloc )
	pcre? ( dev-libs/libpcre )
	pcre-jit? ( dev-libs/libpcre[jit] )
	ssl? ( dev-libs/openssl )

	tengine_shared_modules_http_geoip? ( dev-libs/geoip )
	tengine_shared_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	tengine_shared_modules_http_rewrite? ( dev-libs/libpcre )
	tengine_shared_modules_http_secure_link? ( dev-libs/openssl )
	tengine_shared_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	tengine_shared_modules_http_lua? ( !luajit? ( dev-lang/lua ) luajit? ( dev-lang/luajit ) )

	tengine_static_modules_http_geo? ( dev-libs/geoip )
	tengine_static_modules_http_geoip? ( dev-libs/geoip )
	tengine_static_modules_http_gunzip? ( sys-libs/zlib )
	tengine_static_modules_http_gzip? ( sys-libs/zlib )
	tengine_static_modules_http_gzip_static? ( sys-libs/zlib )
	tengine_static_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	tengine_static_modules_http_perl? ( dev-lang/perl )
	tengine_static_modules_http_rewrite? ( dev-libs/libpcre )
	tengine_static_modules_http_secure_link? ( dev-libs/openssl )
	tengine_static_modules_http_spdy? ( dev-libs/openssl )
	tengine_static_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	tengine_static_modules_http_lua? ( !luajit? ( dev-lang/lua ) luajit? ( dev-lang/luajit ) )"

DEPEND="${RDEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )"

PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

REQUIRED_USE="pcre-jit? ( pcre )"

for module in $TENGINE_MODULES_{STANDARD,OPTIONAL}_SHARED ; do
	REQUIRED_USE+=" tengine_shared_modules_http_${module}? ( !tengine_static_modules_http_${module} )"
done

pkg_setup() {
	TENGINE_HOME="/var/lib/${PN}"
	TENGINE_HOME_TMP="${TENGINE_HOME}/tmp"

	ebegin "Creating tengine user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "${TENGINE_HOME}" ${PN}
	eend $?

	if use libatomic ; then
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if using"
		ewarn "a different compiler or a GCC prior to 4.1"
	fi

	if ! use http ; then
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all tengine http modules."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-perl-install-path.patch"

	sed -e "s;NGX_CONF_PREFIX/nginx.conf;NGX_CONF_PREFIX/tengine.conf;" \
		-i "${S}/auto/install" || die

	if ! use_if_iuse tengine_static_modules_http_charset_filter || ! use_if_iuse tengine_shared_modules_http_charset_filter ; then
		sed -e "s;--without-http_charset_module;--without-http_charset_filter_module;g" \
			-i "${S}/auto/options" || die
	fi

	if ! use_if_iuse tengine_static_modules_http_userid_filter || ! use_if_iuse tengine_shared_modules_http_userid_filter ; then
		sed -e "s;--without-http_userid_module;--without-http_userid_filter_module;g" \
			-i "${S}/auto/options" || die
	fi

	find auto/ -type f -print0 | xargs -0 sed -i 's;\&\& make;\&\& \\$(MAKE);' || die
	# We have config protection, don't rename etc files
	sed -e 's;.default;;' \
		-i "${S}/auto/install" || die
	# Remove useless files
	sed -e "/koi-/d" \
		-e "/win-/d" \
		-i "${S}/auto/install" || die

	# Don't install to /etc/tengine/ if not in use
	local module
	for module in fastcgi scgi uwsgi ; do
		if ! use_if_iuse tengine_static_modules_http_${module} && ! use_if_iuse tengine_shared_modules_http_${module} ; then
			sed -e "/${module}/d" -i auto/install || die
		fi
	done
}

src_configure() {
	local tengine_configure= http_enabled= mail_enabled=

	use aio && tengine_configure+=" --with-file-aio --with-aio_module"
	use backtrace && tengine_configure+=" --with-backtrace_module"
	use debug && tengine_configure+=" --with-debug"
	use google_perftools && tengine_configure+=" --with-google_perftools_module"
	use ipv6 && tengine_configure+=" --with-ipv6"
	use jemalloc && tengine_configure+=" --with-jemalloc"
	use libatomic && tengine_configure+=" --with-libatomic"
	use pcre && tengine_configure+=" --with-pcre"
	use pcre-jit && tengine_configure+=" --with-pcre-jit"
	use rtsig && tengine_configure+=" --with-rtsig_module"

	use dso || tengine_configure+=" --without-dso"
	use syslog || tengine_configure+=" --without-syslog"

	for module in $TENGINE_MODULES_{STANDARD,STANDARD_SHARED} ; do
		if use tengine_static_modules_http_${module} && ! use_if_iuse tengine_shared_modules_http_${module} ; then
			http_enabled=1
		else
			tengine_configure+=" --without-http_${module}_module"
		fi
	done

	for module in $TENGINE_MODULES_STANDARD_SHARED ; do
		if use dso && use_if_iuse tengine_shared_modules_http_${module} && ! use_if_iuse tengine_static_modules_http_${module} ; then
			http_enabled=1
			tengine_configure+=" --with-http_${module}_module=shared"
		elif use dso && ! use_if_iuse tengine_shared_modules_http_${module} && ! use_if_iuse tengine_static_modules_http_${module} ; then
			tengine_configure+=" --without-http_${module}_module"
		fi
	done

	for module in $TENGINE_MODULES_{OPTIONAL,OPTIONAL_SHARED} ; do
		if use_if_iuse tengine_static_modules_http_${module} && ! use_if_iuse tengine_shared_modules_http_${module} ; then
			http_enabled=1
			tengine_configure+=" --with-http_${module}_module"
		fi
	done

	for module in $TENGINE_MODULES_OPTIONAL_SHARED ; do
		if use dso && use_if_iuse tengine_shared_modules_http_${module} && ! use_if_iuse tengine_static_modules_http_${module} ; then
			http_enabled=1
			tengine_configure+=" --with-http_${module}_module=shared"
		fi
	done

	if use_if_iuse tengine_static_modules_http_fastcgi || use_if_iuse tengine_static_modules_http_fastcgi ; then
		tengine_configure+=" --with-http_realip_module"
	fi

	if use http || use http-cache; then
		http_enabled=1
	fi


	if [[ -n "${http_enabled}" ]] ; then
		use http-cache || tengine_configure+=" --without-http-cache"
		use ssl && tengine_configure+=" --with-http_ssl_module"
	else
		tengine_configure+=" --without-http --without-http-cache"
	fi

	for module in $TENGINE_MODULES_MAIL; do
		if use_if_iuse tengine_modules_mail_${module}; then
			mail_enabled=1
		else
			tengine_configure+=" --without-mail_${module}_module"
		fi
	done

	if [[ -n "${mail_enabled}" ]] ; then
		tengine_configure+=" --with-mail"
		use ssl && tengine_configure+=" --with-mail_ssl_module"
	fi

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export CC

	if ! use prefix ; then
		tengine_configure+=" --user=${PN} --group=${PN}"
	fi

	./configure \
		--sbin-path="${EPREFIX}/usr/sbin/${PN}" \
		--dso-path="${EPREFIX}/${TENGINE_HOME}/modules" \
		--dso-tool-path="${EPREFIX}/usr/sbin/dso_tool" \
		--prefix="${EPREFIX}/usr" \
		--conf-path="${EPREFIX}/etc/${PN}/${PN}.conf" \
		--error-log-path="${EPREFIX}/var/log/${PN}/error_log" \
		--pid-path="${EPREFIX}/run/${PN}.pid" \
		--lock-path="${EPREFIX}/run/lock/${PN}.lock" \
		--with-cc-opt="-I${EROOT}usr/include" \
		--with-ld-opt="-L${EROOT}usr/$(get_libdir)" \
		--http-log-path="${EPREFIX}/var/log/${PN}/access_log" \
		--http-client-body-temp-path="${EPREFIX}/${TENGINE_HOME_TMP}/client" \
		--http-proxy-temp-path="${EPREFIX}/${TENGINE_HOME_TMP}/proxy" \
		--http-fastcgi-temp-path="${EPREFIX}/${TENGINE_HOME_TMP}/fastcgi" \
		--http-scgi-temp-path="${EPREFIX}/${TENGINE_HOME_TMP}/scgi" \
		--http-uwsgi-temp-path="${EPREFIX}/${TENGINE_HOME_TMP}/uwsgi" \
		$(use_with poll poll_module) \
		$(use_with select select_module) \
		${tengine_configure} || die

	# A purely cosmetic change that makes tengine -V more readable. This can be
	# good if people outside the gentoo community would troubleshoot and
	# question the users setup.
	sed -i -e "s|${WORKDIR}|external_module|g" objs/ngx_auto_config.h || die
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}"
}

src_install() {
	if use_if_iuse tengine_static_modules_http_perl ; then
		sed '/CORE_LINK/{ N; s/CORE_LINK=.\(.*\).$/CORE_LINK="\1"/ }' \
			-i "${S}/objs/dso_tool" || die
	fi

	emake DESTDIR="${D}" install

	cp "${FILESDIR}/${PN}.conf" "${ED}/etc/${PN}/${PN}.conf" || die

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

    systemd_newunit "${FILESDIR}"/tengine.service-r1 tengine.service

	dodir /etc/${PN}/sites-{available,enabled}
	insinto /etc/${PN}/sites-available
	doins ${FILESDIR}/sites-available/localhost
	dodir /usr/share/tengine/html
	insinto /usr/share/tengine/html
	doins ${FILESDIR}/example/index.html
	doins ${FILESDIR}/example/nginx-logo.png
	doins ${FILESDIR}/example/powered-by-funtoo.png

	newman man/nginx.8 ${PN}.8
	dodoc CHANGES* README

	# just keepdir. do not copy the default htdocs files (bug #449136)
	keepdir /var/www/localhost
	rm -r "${D}/usr/html" || die

	# set up a list of directories to keep
	local keepdir_list="${TENGINE_HOME_TMP}"/client
	local module
	for module in proxy fastcgi scgi uwsgi ; do
		use_if_iuse tengine_static_modules_http_${module} && keepdir_list+=" ${TENGINE_HOME_TMP}/${module}"
	done

	keepdir /var/log/${PN} ${keepdir_list}

	fperms 0700 ${EROOT}/var/log/${PN} ${keepdir_list}
	fowners ${PN}:${PN} ${EROOT}/var/log/${PN} ${keepdir_list}

	# logrotate
	insinto ${EROOT}/etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	if use_if_iuse tengine_static_modules_http_perl ; then
		cd "${S}/objs/src/http/modules/perl"
		einstall DESTDIR="${D}" INSTALLDIRS=vendor
		perl_delete_localpod
	fi
}

pkg_preinst() {
	if [[ ! -d "${EROOT}"/etc/${PN}/sites-available ]] ; then
		first_install=yes
	else
		first_install=no
	fi
}

pkg_postinst() {
	if [[ "${first_install}" = "yes" ]] && [[ ! -e "${EROOT}/etc/${PN}/sites-enabled/localhost" ]] ; then
		einfo "Enabling example Web site (see http://127.0.0.1)"
		# enable example Web site (listens on localhost only)
		ln -s ../sites-available/localhost "${EROOT}/etc/${PN}/sites-enabled/localhost"
	fi

	if use ssl ; then
		if [[ ! -f "${EROOT}/etc/ssl/${PN}/${PN}.key" ]] ; then
			install_cert /etc/ssl/${PN}/${PN}
			use prefix || chown ${PN}:${PN} "${EROOT}/etc/ssl/${PN}"/${PN}.{crt,csr,key,pem}
		fi
	fi

	einfo "If tengine complains about insufficient number of open files at start, ensure"
	einfo "that you have a current /etc/security/limits.conf and logout and log back in"
	einfo "to your system to ensure that the new max open file limits are active. Then"
	einfo "try restarting tengine again."

	# If the tengine user can't change into or read the dir, display a warning.
	# If su is not available we display the warning nevertheless since we can't check properly
	su -s /bin/sh -c "cd /var/log/${PN} && ls" ${PN} >&/dev/null
	if [ $? -ne 0 ] ; then
		ewarn "Please make sure that the tengine user or group has at least"
		ewarn "'rx' permissions on /var/log/${PN} (default on a fresh install)"
		ewarn "Otherwise you end up with empty log files after a logrotate."
	fi
}
