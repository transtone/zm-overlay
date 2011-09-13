# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Namebench hunts down the fastest DNS server avaiable for your computer to use."
HOMEPAGE="http://code.google.com/p/namebench/"
SRC_URI="http://namebench.googlecode.com/files/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
EAPI="2"
KEYWORDS="~x86 ~amd64"
IUSE="tk"

DEPEND="<=dev-lang/python-3
	tk? ( <=dev-lang/python-3[tk] )"
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
}
