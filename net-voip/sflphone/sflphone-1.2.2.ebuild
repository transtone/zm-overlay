# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/sflphone/sflphone-1.0.1.ebuild,v 1.3 2012/03/02 14:58:32 elvanor Exp $

EAPI=5

inherit autotools eutils gnome2 cmake-utils

DESCRIPTION="A robust standards-compliant enterprise softphone"
HOMEPAGE="http://www.sflphone.org/"
SRC_URI="http://projects.savoirfairelinux.com/attachments/download/5064/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doxygen gnome gsm iax kde networkmanager speex static-libs portaudio pulseaudio"

CDEPEND="dev-cpp/commoncpp2
	dev-libs/dbus-c++
	dev-libs/expat
	dev-libs/openssl
	dev-libs/libpcre
	dev-libs/libyaml
	media-libs/alsa-lib
	media-libs/celt
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	media-libs/libilbc
	media-libs/libsamplerate
	net-libs/ccrtp
	net-libs/iax
	net-libs/libzrtpcpp
	>=net-libs/pjsip-2.1
	sys-apps/dbus
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	networkmanager? ( net-misc/networkmanager )
	gnome? ( dev-libs/atk
		dev-libs/check
		dev-libs/log4c
		gnome-base/libgnomeui
		gnome-base/orbit:2
		gnome-extra/evolution-data-server
		media-libs/fontconfig
		media-libs/freetype
		media-libs/libart_lgpl
		net-libs/libsoup:2.4
		net-libs/webkit-gtk:3
		x11-libs/cairo
		x11-libs/libICE
		x11-libs/libnotify
		x11-libs/libSM )
	kde? ( x11-libs/qt4
		   app-office/akonadi-server[sqlite] )"

DEPEND="${CDEPEND}
		>=dev-util/astyle-1.24
		doxygen? ( app-doc/doxygen )
		gnome? ( app-text/gnome-doc-utils )"

RDEPEND="${CDEPEND}"
CMAKE_USE_DIR="${S}/kde"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch" \
		   "${FILESDIR}/${P}-ilbc.patch" \
		   "${FILESDIR}/${P}-noqttest.patch"

	if ! use gnome || ! use kde; then
		ewarn
		ewarn "No clients selected. Use USE=gnome to get the gnome client."
		ewarn "See"
		ewarn "https://projects.savoirfairelinux.com/repositories/browse/sflphone/tools/pysflphone"
		ewarn "for a python command line client."
		ewarn
	fi

	cd daemon
	#remove "target" from lib-names, remove dep to shipped pjsip
	sed -i -e 's/-$(target)//' \
		-e '/^\t\t\t-L/ d' \
		-e 's!-I$(src)/libs/pjproject!-I/usr/include!' \
		globals.mak || die "sed failed."
	#respect CXXFLAGS
	sed -i -e 's/CXXFLAGS="-g/CXXFLAGS="-g $CXXFLAGS /' \
		configure.ac || die "sed failed."
	rm -r libs/pjproject-2.0.1
	eautoreconf

	#TODO: remove shipped utilspp (from curlpp), use system one, see #55185

	if use gnome; then
		cd ../gnome
		#fix as-needed
		sed -i -e "s/X11_LIBS)/X11_LIBS) -lebook-1.2/" src/Makefile.am || die "sed failed."
		eautoreconf
	fi
}

src_configure() {
	cd daemon
	econf --disable-dependency-tracking $(use_with debug) \
		$(use_with gsm) \
		$(use_with networkmanager) \
		$(use_with speex) \
		$(use_enable static-libs static) \
		$(use_enable doxygen) \
		$(use_with iax iax2)

	if use gnome; then
		cd ../gnome
		econf $(use_enable static-libs static)
	fi
	if use kde; then
		cmake-utils_src_configure
	fi
	export APP_LDFLAGS=$(pkg-config --libs libpjproject)
}

src_compile() {
	cd daemon
	emake

	if use gnome; then
		cd ../gnome
		emake
	fi
	if use kde; then
		cmake-utils_src_make
	fi
}

src_install() {
	cd daemon
	emake -j1 DESTDIR="${D}" install
	dodoc test/sflphonedrc-sample

	if use gnome; then
		cd ../gnome
		gnome2_src_install
	fi
	if use kde; then
		cmake-utils_src_install
	fi
}

pkg_postinst() {
	elog
	elog "You need to restart dbus, if you want to access"
	elog "sflphoned through dbus."
	elog
	elog
	elog "If you use the command line client"
	elog "(https://projects.savoirfairelinux.com/repositories/browse/sflphone/tools/pysflphone)"
	elog "extract /usr/share/doc/${PF}/${PN}drc-sample to"
	elog "~/.config/${PN}/${PN}drc for example config."
	elog
	elog
	elog "For calls out of your browser have a look in sflphone-callto"
	elog "and sflphone-handler. You should consider to install"
	elog "the \"Telify\" Firefox addon. See"
	elog "https://projects.savoirfairelinux.com/repositories/browse/sflphone/tools"
	elog
	if use gnome; then
		gnome2_pkg_postinst
		elog
		elog "sflphone-client-gnome: To manage your contacts you need"
		elog "mail-client/evolution or access to an evolution-data-server"
		elog "connected backend."
		elog
	fi
}
