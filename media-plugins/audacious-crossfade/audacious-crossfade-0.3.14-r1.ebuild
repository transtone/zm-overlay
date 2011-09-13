# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Based on audacious-crossfade-0.3.12.ebuild,v 1.2 2007/11/10 15:52:16 joker
# By Michal Lipski <tallica@o2.pl>

inherit eutils versionator
 
IUSE="samplerate"
U_PN="xmms-crossfade"

DESCRIPTION="Audacious plugin for crossfading and continuous output. Also know as xmms-crossfade"
HOMEPAGE="http://www.eisenlohr.org/xmms-crossfade/index.html"
SRC_URI="http://www.eisenlohr.org/${U_PN}/${U_PN}-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="media-sound/audacious
	samplerate? ( media-libs/libsamplerate )"

S="${WORKDIR}/${U_PN}-${PV}"

src_unpack() {
	unpack ${A}
	cd ${S}

	einfo "Applying patches..."

	epatch "${FILESDIR}"/oss.c.patch \
			|| die "oss.c patch failed"
}

src_compile() {
	econf \
	      --enable-player=audacious \
	      --libdir="`pkg-config audacious --variable=output_plugin_dir`" \
	      $(use_enable samplerate) \
	      || die

	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README TODO
}

