# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit cmake-utils mercurial

EHG_REVISION="default"
EHG_REPO_URI="https://fcitx.googlecode.com/hg"
#EHG_UP_FREQ="12"

DESCRIPTION="Free Chinese Input Toy for X. Another Chinese XIM Input Method"
HOMEPAGE="http://fcitx.googlecode.com"
SRC_URI="${HOMEPAGE}/files/pinyin.tar.gz
		 ${HOMEPAGE}/files/table.tar.gz
		 https://github.com/transtone/transconfig/raw/master/zm.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+cairo +pango +gtk gtk3 +qt opencc debug test static-libs +table zhengma "
RESTRICT="mirror"

RDEPEND="media-libs/fontconfig
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libXrender
	qt? ( x11-libs/qt-gui:4
			  x11-libs/qt-dbus:4 )
		opencc? ( app-i18n/opencc )
	pango? ( x11-libs/pango )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
	x11-proto/xproto"

update_gtk_immodules() {
	local GTK2_CONFDIR="/etc/gtk-2.0"
	# bug #366889
	if has_version '>=x11-libs/gtk+-2.22.1-r1:2' || has_multilib_profile; then
		GTK2_CONFDIR="${GTK2_CONFDIR}/$(get_abi_CHOST)"
	fi
	mkdir -p "${EPREFIX}${GTK2_CONFDIR}"
	if [ -x "${EPREFIX}/usr/bin/gtk-query-immodules-2.0" ]; then
		"${EPREFIX}/usr/bin/gtk-query-immodules-2.0" > "${EPREFIX}${GTK2_CONFDIR}/gtk.immodules"
	fi
}

update_gtk3_immodules() {
	if [ -x "${EPREFIX}/usr/bin/gtk-query-immodules-3.0" ]; then
		"${EPREFIX}/usr/bin/gtk-query-immodules-3.0" --update-cache
	fi
}

src_prepare() {
	cp -v "${DISTDIR}"/pinyin.tar.gz "${S}"/data && \
	cp -v "${DISTDIR}"/table.tar.gz "${S}"/data/table || \
	die "failed to copy code tables"

	if use zhengma ; then
		cp -v "${DISTDIR}"/zm.tar.gz "${S}"/data/table || die "failed to copy zhengma table"
		cp "${FILESDIR}"/zhengma.conf.in "${S}"/data/table/zhengma.conf.in
		cp "${FILESDIR}"/fcitx-zhengma.png "${S}"/data/png/fcitx-zhengma.png
		cp "${FILESDIR}"/fcitx-zhengma-22.png "${S}"/skin/dark/zhengma.png
		cp "${FILESDIR}"/fcitx-zhengma-16.png "${S}"/skin/classic/zhengma.png
		cp "${FILESDIR}"/fcitx-zhengma-16.png "${S}"/skin/default/zhengma.png
		epatch "${FILESDIR}"/zhengma.diff
	fi

}

src_configure() {
	local mycmakeargs=(
			$(cmake-utils_use_enable cairo CAIRO ) \
			$(cmake-utils_use_enable debug DEBUG ) \
			$(cmake-utils_use_enable gtk GTK2_IM_MODULE ) \
			$(cmake-utils_use_enable gtk3 GTK3_IM_MODULE ) \
			$(cmake-utils_use_enable opencc OPENCC ) \
			$(cmake-utils_use_enable pango PANGO ) \
			$(cmake-utils_use_enable qt QT_IM_MODULE ) \
			$(cmake-utils_use_enable static-libs STATIC ) \
			$(cmake-utils_use_enable table TABLE ) \
			$(cmake-utils_use_enable test TEST )
	)
	cmake-utils_src_configure
}


pkg_postinst() {
	use gtk && update_gtk_immodules
	use gtk3 && update_gtk3_immodules
	elog
	elog "You should export the following variables to use fcitx"
	elog " export XMODIFIERS=\"@im=fcitx\""
	elog " export XIM=fcitx"
	elog " export XIM_PROGRAM=fcitx"
	elog
}


pkg_postrm() {
	use gtk && update_gtk_immodules
	use gtk3 && update_gtk3_immodules
}
