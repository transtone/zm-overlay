# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="lightweight volume control that sits in your systray"
HOMEPAGE="http://www.softwarebakery.com/maato/volumeicon.html"
SRC_URI="http://www.softwarebakery.com/maato/files/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="oss"

RDEPEND="media-libs/alsa-lib
      >=x11-libs/gtk+-2.16"
DEPEND="${RDEPEND}"

src_compile() {
	if use oss; then
  		econf --enable-oss
	fi
	emake || die
}
		

src_install() {
   emake DESTDIR="${D}" install || die
   dodoc ChangeLog README || die
} 
