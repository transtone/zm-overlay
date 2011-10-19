# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-init-scripts/mysql-init-scripts-2.0_pre1-r2.ebuild,v 1.1 2011/01/15 17:54:31 robbat2 Exp $

DESCRIPTION="Gentoo uwsgi init scripts"
HOMEPAGE="https://github.com/transtone/zm-overlay/tree/master/www-servers/uwsgi-init-scripts http://transtone.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="!www-servers/uwsgi"

src_install() {
	newconfd "${FILESDIR}/uwsgi.confd" "uwsgi"
	newinitd "${FILESDIR}/uwsgi.initd" "uwsgi"
	mkdir -p "${ED}"/var/run/uwsgi
}

pkg_postinst() {
	elog "please run \"pip install uwsgi\" in your virtualenv first. "
}
