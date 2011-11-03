# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdemud/cdemud-1.4.0.ebuild,v 1.4 2011/10/27 15:34:33 ssuominen Exp $

EAPI="2"

DESCRIPTION="Daemon of the cdemu cd image mounting suite"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/cdemu-daemon-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa pulseaudio"

RDEPEND=">dev-libs/dbus-glib-0.6
	>=dev-libs/libdaemon-0.10
	>=dev-libs/libmirage-1.4.0
	media-libs/libao[alsa?,pulseaudio?]
	>=sys-fs/vhba-20110915"
DEPEND="${RDEPEND}"

S=${WORKDIR}/cdemu-daemon-${PV}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README || die
}

