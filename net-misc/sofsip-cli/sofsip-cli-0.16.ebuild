# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

DESCRIPTION="A console VoIP/IM SIP client based on sofia-sip"
HOMEPAGE="http://wiki.opensource.nokia.com/projects/SofSipCli
http://sofia-sip.sourceforge.net/development.html"
SRC_URI="mirror://sourceforge/sofia-sip/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/sofia-sip-1.12.3
	>=media-libs/gstreamer-0.10.2
	sys-libs/readline"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README NEWS TODO AUTHORS || die
}
