# Copyright 1999-2010 Tiziano Müller
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib toolchain-funcs

VB_V="4.1.8"
VB_P="VirtualBox-${VB_V}"

DESCRIPTION="Fuse module to open a VBox supported VD image file and mount it."
HOMEPAGE="http://forums.virtualbox.org/viewtopic.php?f=7&t=17574"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-emulation/virtualbox
	sys-fs/fuse"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}"

pkg_setup() {
	ewarn "You may have to make /usr/$(get_libdir)/virtualbox-ose/VBox{DDU,RT}.so"
	ewarn "readable for everyone first."
}

src_unpack() {
	tar xjpf "${FILESDIR}/${VB_P}-include-only.tar.bz2" || die "unpacking VirtualBox headers failed"
	cp "${FILESDIR}/vdfuse-v${PV}.c" .
}

src_compile() {
	$(tc-getCC) \
		${CFLAGS} \
		$(pkg-config --cflags fuse) \
		${LDFLAGS} \
		"vdfuse-v${PV}.c" \
		-o vdfuse \
		-I${VB_P}_OSE/include \
		$(pkg-config --libs fuse) \
		-l:/usr/$(get_libdir)/virtualbox/VBoxDDU.so \
		-Wl,-rpath,/usr/$(get_libdir)/virtualbox \
		|| die "building vdfuse failed"
}

src_install() {
	dobin vdfuse
}


