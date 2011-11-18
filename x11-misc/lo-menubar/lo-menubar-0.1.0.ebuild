# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit

DESCRIPTION="A small plugin for LibreOffice to export the menus from the application into Unity's menubar."
HOMEPAGE="https://launchpad.net/lo-menubar"
SRC_URI=" x86? ( https://launchpad.net/ubuntu/+source/${PN}/${PV}-0ubuntu3/+build/2774800/+files/${PN}_${PV}-0ubuntu3_i386.deb )
		  amd64? ( https://launchpad.net/ubuntu/+source/${PN}/${PV}-0ubuntu3/+build/2774798/+files/${PN}_${PV}-0ubuntu3_amd64.deb )"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

CDEPEND=""
DEPEND="|| ( app-office/libreoffice-bin app-office/libreoffice )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"
src_prepare(){
   unpack ${A}
   unpack ./data.tar.gz
   mkdir -p ${WORKDIR}/tmp/usr/lib/libreoffice/share/extensions/
}
src_install(){
  cp -R usr/lib/libreoffice/share/extensions/menubar ${WORKDIR}/tmp/usr/lib/libreoffice/share/extensions/
  cp -R ${WORKDIR}/tmp/* "${D}"
}