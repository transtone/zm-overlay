# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/gcdemu/gcdemu-1.3.0.ebuild,v 1.3 2011/06/13 15:00:52 pacho Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="gCDEmu is a GNOME applet for controlling CDEmu daemon"
HOMEPAGE="http://cdemu.org/"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

COMMON_DEPEND=">=dev-python/pygtk-2.6
	>=dev-python/pygobject-2.6
	>=dev-python/dbus-python-0.71
	>=app-cdr/cdemud-1.4.0"
DEPEND="${COMMON_DEPEND}
	dev-python/gconf-python
	dev-util/pkgconfig
	dev-util/intltool"
RDEPEND="${COMMON_DEPEND}
	libnotify? ( dev-python/notify-python )"

DOCS="AUTHORS ChangeLog README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-schemas-install"
	DOCS="AUTHORS ChangeLog* NEWS README"
}

src_install() {
	emake DESTDIR="${ED}" install || die
}
