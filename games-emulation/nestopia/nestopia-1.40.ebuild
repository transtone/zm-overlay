# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

MY_PV="${PV//./}"
LNX_P="nst${MY_PV}_lnx_release_h"

DESCRIPTION="NEStopia is a portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://rbelmont.mameworld.info/?page_id=200"
SRC_URI="mirror://sourceforge/${PN}/Nestopia${MY_PV}src.zip
		http://rbelmont.mameworld.info/${LNX_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

DEPEND=">=x11-libs/gtk+-2.4
		media-libs/alsa-lib
		>=media-libs/libsdl-1.2.12
		virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

pkg_nofetch() {
		einfo "Please download ${LNX_P}.zip"
		einfo "from ${HOMEPAGE}"
		einfo "and move it to ${DISTDIR}"
}


src_prepare() {
		sed -i Makefile -e "s:CFLAGS = -c -O3 -g3:CFLAGS += -c:" \
			|| die "sed failed"
}

src_compile() {
		# parallel make seems broken
		emake -j1 || die "emake failed"
}

src_install() {
		insinto "${GAMES_DATADIR}/${PN}"
		doins NstDatabase.xml nstcontrols

		newgamesbin nst ${PN}.bin

		sed \
		-e "s:%GAMES_DATADIR%:${GAMES_DATADIR}:g" \
		"${FILESDIR}/${PN}" \
		> "${D}/${GAMES_BINDIR}/${PN}" \
		|| die "sed failed"

		dodoc README.Linux changelog.txt
		dohtml -r readme.html doc/*.html doc/details

		prepgamesdirs
}

