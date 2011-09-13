# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx/fcitx-4.0.1.ebuild,v 1.2 2010/12/19 02:48:24 qiaomuf Exp $

EAPI="3"

inherit eutils

DESCRIPTION="Free Chinese Input Toy for X. Another Chinese XIM Input Method"
HOMEPAGE="http://www.fcitx.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}_all.tar.gz
https://github.com/transtone/transconfig/raw/master/zmmb.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus pango zhengma"

RDEPEND="!<=app-i18n/fcitx-configtool-0.1.4
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/cairo[X]
	media-libs/fontconfig
	pango? ( x11-libs/pango )
	dbus? ( >=sys-apps/dbus-0.2 )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	dev-util/pkgconfig"


src_prepare() {
	# fix a bug when compiling without pango
	epatch "${FILESDIR}/${P}-fix-pango.patch"
	# Add zhengma support
	if use zhengma ; then
		cp "${DISTDIR}"/zmmb.tar.gz "${S}"/data/table
		cp "${FILESDIR}"/zhengma.conf "${S}"/data/table/zhengma.conf
		cp "${FILESDIR}"/fcitx-zhengma.png "${S}"/png/fcitx-zhengma.png
		cp "${FILESDIR}"/fcitx-zhengma-22.png "${S}"/skin/dark/zhengma.png
		cp "${FILESDIR}"/fcitx-zhengma-16.png "${S}"/skin/classic/zhengma.png
		cp "${FILESDIR}"/fcitx-zhengma-16.png "${S}"/skin/default/zhengma.png
		epatch "${FILESDIR}"/zhengma-4.0.1.diff
	fi


}

src_configure() {
	econf \
		$(use_enable dbus) \
		$(use_enable pango) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README THANKS TODO || die

	rm -rf "${ED}"/usr/share/fcitx/doc/ || die
	dodoc doc/pinyin.txt doc/cjkvinput.txt || die
	dohtml doc/wb_fh.htm || die
}

pkg_postinst() {
	elog
	elog "You should export the following variables to use fcitx"
	elog " export XMODIFIERS=\"@im=fcitx\""
	elog " export XIM=fcitx"
	elog " export XIM_PROGRAM=fcitx"
	elog
}
