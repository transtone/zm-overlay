# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-appmenu-plugin/xfce4-appmenu-plugin-9999.ebuild,v 1.1 2011/11/18 15:23:41 angelos Exp $

EAPI=4
inherit xfconf 

DESCRIPTION="A panel plugin that enables indicator appmenu in XFCE environment"
HOMEPAGE="https://gitorious.org/xfce-appmenu-plugin/"
SRC_URI="https://gitorious.org/xfce-appmenu-plugin/xfce-appmenu-plugin/archive-tarball/master -> ${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND=">=dev-libs/libindicator-0.4.0
	x11-libs/gtk+:2
	x11-misc/indicator-appmenu
	xfce-extra/xfce4-indicator-plugin"
DEPEND=${RDEPEND}


pkg_setup() {
	XFCONF=( --disable-static $(xfconf_use_debug) )
        DOCS=( AUTHORS ChangeLog NEWS THANKS )
}
