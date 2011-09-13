# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools git

MY_PN="moblin-gtk-engine"

DESCRIPTION="Mobline GTK+ Cairo Engine"
HOMEPAGE="http://www.moblin.org/"
SRC_URI=""
EGIT_REPO_URI="git://repo.or.cz/moblin-gtk-engine.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8.0"
DEPEND="${RDEPEND}
dev-util/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog README NEWS
}
