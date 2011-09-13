# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils autotools

EGIT_REPO_URI="git://git.gnome.org/murrine"
EGIT_BOOTSTRAP="autogen.sh"
DESCRIPTION="Murrine GTK+2 Cairo Engine"

HOMEPAGE="http://www.cimitan.com/murrine/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="themes animation-rtl"

RDEPEND=">=x11-libs/gtk+-2.12
	themes? ( x11-themes/murrine-themes )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf --enable-animation \
		--enable-rgba \
		$(use_enable animation-rtl animationrtl)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog TODO
}
