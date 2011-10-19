# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/uwsgi-init-scripts/uwsgi-init-scripts-0.1.ebuild,v 0.1 2011/10/19 08:33:00 transtone Exp $

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
