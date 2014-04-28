# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="MATE default icon themes"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"

DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	sys-devel/gettext"

DOCS="AUTHORS NEWS TODO"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_configure() {
	DOCS="AUTHORS NEWS TODO"

	gnome2_src_configure --enable-icon-mapping
}
