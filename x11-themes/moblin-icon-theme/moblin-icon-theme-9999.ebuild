# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools gnome2-utils git

DESCRIPTION="SVG and PNG icon theme from the Moblin project"
HOMEPAGE="http://repo.or.cz/w/moblin-icon-theme.git"
SRC_URI=""
EGIT_REPO_URI="git://repo.or.cz/moblin-icon-theme.git"
EGIT_BRANCH="one-size"
EGIT_COMMIT="one-size"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-misc/icon-naming-utils-0.8.7"
DEPEND="${RDEPEND}
dev-util/pkgconfig"

src_prepare() {
	./create-icon-theme.sh moblin || die "create-icon-theme failed!"
	cd output/moblin
	eautoreconf
}

src_configure() {
	cd output/moblin
	default_src_configure
}

src_compile() {
	cd output/moblin
	default_src_compile
}

src_install() {
	cd output/moblin
	emake DESTDIR="${D}" install || die "emake install failed"
	cd "${S}"
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
