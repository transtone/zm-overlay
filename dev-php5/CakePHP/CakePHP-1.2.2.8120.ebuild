# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils webapp depend.php

# NOTE: This download ID changes every release! Please adjust it accordingly.
DLID=713

DESCRIPTION="CakePHP is an open source MVC framework for developing PHP web applications."
HOMEPAGE="http://www.cakephp.org/"
SRC_URI="http://cakeforge.org/frs/download.php/${DLID}/${PV}.tar.gz/donation=complete/${PV}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/cake_${PV}

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup

	require_php_with_use xml pcre session sockets apache2
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# 'empty' files are only here as some SCMs don't track empty folders.
	# We can safely delete them.
	ebegin "Removing unnecessary 'empty' files"
	find ./ -type f -name empty -size 0 -delete &> /dev/null
	eend

	ebegin "Cleaning up some files"
	mkdir docs
	mv README docs/
	mv cake/VERSION.txt docs/
	rm -f cake/LICENSE.txt
	rm -f cake/console/cake.bat
	eend
}

src_install() {
	webapp_src_preinst

	dodoc ${S}/docs/*
	rm -rf ${S}/docs/

	insinto "${MY_HTDOCSDIR}"
	doins -r .htaccess *
	
	# /app/tmp and all its subdirectories need server write permission
	webapp_serverowned "${MY_HTDOCSDIR}"/app/tmp/
	webapp_serverowned "${MY_HTDOCSDIR}"/app/tmp/cache/
	webapp_serverowned "${MY_HTDOCSDIR}"/app/tmp/logs/
	webapp_serverowned "${MY_HTDOCSDIR}"/app/tmp/sessions/
	webapp_serverowned "${MY_HTDOCSDIR}"/app/tmp/tests/

	webapp_src_install
}

pkg_postinst() {
	elog "----------------------------------------------------------"
	elog "For more information, please take a look at the manual at:"
	elog "http://manual.cakephp.org"
	elog "----------------------------------------------------------"
	elog "Dont't forget to configure an empty vhost with enabled"
	elog "mod_rewrite and set up CakePHP using"
	elog "    # webapp-config -I ${PN} ${PV} -h <hostname>"
	elog "----------------------------------------------------------"
}
