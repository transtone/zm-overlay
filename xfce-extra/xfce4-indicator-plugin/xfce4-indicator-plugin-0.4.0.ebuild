# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-indicator-plugin/xfce4-indicator-plugin-0.3.1.ebuild,v 1.1 2011/07/16 15:23:41 angelos Exp $

EAPI=4
inherit xfconf

DESCRIPTION="A panel plugin that uses indicator-applet to show new messages"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-indicator-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.4/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND=">=dev-libs/libindicator-0.4.0
	x11-libs/gtk+:2
	>=xfce-base/libxfce4util-4.3.99.2
	>=xfce-base/xfce4-panel-4.3.99.2"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	XFCONF=( --disable-static $(xfconf_use_debug) )
	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
