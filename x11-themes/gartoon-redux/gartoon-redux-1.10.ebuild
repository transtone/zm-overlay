# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

inherit eutils

DESCRIPTION="Gartoon Redux Icon Theme"
SRC_URI="http://tweenk.artfx.pl/gartoon/source/${P}.tar.gz"
HOMEPAGE="http://www.gnome-look.org/content/show.php/?content=74841"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="gnome-base/librsvg
	dev-lang/perl"
DEPEND="${RDEPEND}"

RESTRICT="binchecks strip"

#S="${WORKDIR}/${P}"
MY_DEST="/usr/share/icons/${PN}"
MY_PREFIX="/usr"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/configure.patch"
}
src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake icondir=${D}${MY_DEST} DESTDIR=${D} install
	dodoc AUTHORS changelog COPYING TODO README
}
