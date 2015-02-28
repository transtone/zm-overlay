# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit cmake-utils eutils gnome2-utils

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="A lightweight panel/taskbar"
HOMEPAGE="http://code.google.com/p/tint2"
SRC_URI="http://tint2.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="battery examples tint2conf"

PDEPEND="tint2conf? ( x11-misc/tintwizard )"

RDEPEND="dev-libs/glib:2
	media-libs/imlib2[X]
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/libXrandr
	x11-libs/pango[X]"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xineramaproto"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-battery-segfault.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable battery BATTERY)
		$(cmake-utils_use_enable examples EXAMPLES)
		$(cmake-utils_use_enable tint2conf TINT2CONF)

		"-DDOCDIR=/usr/share/doc/${PF}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use tint2conf ; then
		rm "${D}/usr/bin/tintwizard.py" || die
	fi
}
