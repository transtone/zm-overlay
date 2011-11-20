# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxde-meta/lxde-meta-0.5.5.ebuild,v 1.4 2011/10/09 16:51:39 maekke Exp $

EAPI="2"

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.sf.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ppc x86"
IUSE=""

RDEPEND="=lxde-base/lxappearance-0.5*
	=lxde-base/lxmenu-data-0.1*
	=lxde-base/lxpanel-0.5.8*
	=lxde-base/lxtask-0.1*
	x11-misc/pcmanfm
	x11-misc/obconf
	x11-misc/obmenu
	x11-wm/openbox"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "http://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
