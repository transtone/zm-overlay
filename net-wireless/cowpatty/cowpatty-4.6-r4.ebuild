# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="WLAN tools for bruteforcing 802.11 WPA/WPA2 keys"
HOMEPAGE="http://www.willhackforsushi.com/Cowpatty.html"
SRC_URI="http://www.willhackforsushi.com/code/${PN}/${PV}/${P}.tgz"

inherit eutils

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND="dev-libs/openssl
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_compile() {
	epatch ${FILESDIR}/cowpatty-4.6-fixup14.patch
	emake -j1 || die "emake failed"
}

src_install() {
        dobin cowpatty genpmk  || die "dobin failed"
        dodoc AUTHORS CHANGELOG FAQ INSTALL README TODO dict *.dump
}
