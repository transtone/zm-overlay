# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.8.1.ebuild,v 1.8 2008/03/21 06:18:04 drac Exp $

inherit eutils gnome2-utils

DESCRIPTION="Icon theme from KDE4"
HOMEPAGE="http://gnome-look.org/content/show.php/Oxygen+Refit+2?content=79756"
SRC_URI="http://download.tuxfamily.org/gnome4sid/OxygenRefit2-${PV}.tar.bz2"

LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd"

RESTRICT="binchecks strip"

RDEPEND=">=x11-misc/icon-naming-utils-0.8.2
	media-gfx/imagemagick
	>=gnome-base/librsvg-2.12.3
	>=x11-themes/hicolor-icon-theme-0.9"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_install() {
	dodir /usr/share/icons
	mv "${WORKDIR}"/OxygenRefit2 "${D}"/usr/share/icons
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

