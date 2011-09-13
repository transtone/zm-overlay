# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="It gives users the opportunity to configure all the Murrine Engine style options"
HOMEPAGE="http://www.cimitan.com/murrine/node/36"
SRC_URI="http://www.cimitan.com/murrine/files/nmc.tar_3.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-themes/gtk-engines-murrine"
RDEPEND="${DEPEND} \
	dev-python/pygtk"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	tar -xvf nmc.tar_3
}

src_compile() {
		einfo "Nothing to compile"
}

src_install() {
	insopts -m0644
	insinto /usr/share/pixmaps
	doins newmurrineconfigurator/src/murrine-configurator.png
	insinto /usr/share/applications/
	doins newmurrineconfigurator/src/murrine-configurator.desktop
	dodir /usr/share/nmc
	insinto /usr/share/nmc
	doins newmurrineconfigurator/src/*.py*
	doins newmurrineconfigurator/src/*.glade
	insopts -m0755
	doins newmurrineconfigurator/src/newmurrineconfigurator.py
}
