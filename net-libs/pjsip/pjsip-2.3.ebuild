# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/pjsip/pjsip-2.1-r2.ebuild,v 1.3 2014/03/09 13:07:51 aballier Exp $

EAPI="5"

inherit eutils multilib

DESCRIPTION="Multimedia communication libraries written in C language for building VoIP applications"
HOMEPAGE="http://www.pjsip.org/"
SRC_URI="http://www.pjsip.org/release/${PV}/pjproject-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cli doc examples ext-sound g711 g722 g7221 gsm l16 oss python speex +srtp ssl video"

DEPEND="alsa? ( media-libs/alsa-lib )
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	srtp? ( net-libs/libsrtp )
	ssl? ( dev-libs/openssl )
	media-libs/libsamplerate
	media-libs/portaudio
	sys-apps/util-linux
	video? ( >=virtual/ffmpeg-9 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/pjproject-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}-libsamplerate.patch" \
		"${FILESDIR}/no_libasound.patch" \
		"${FILESDIR}/reduce_pjmedia_linkage.patch" \
		"${FILESDIR}/reduce_pjlib_linkage.patch"
	epatch_user
	rm -rf third_party/{gsm,ilbc,portaudio,resample,speex,srtp}
}

src_configure() {
	# Disable through portage available codecs
	# libdir should be defined explicitly, bug #497744
	econf \
		--libdir="/usr/$(get_libdir)" \
		--enable-libsamplerate \
		--disable-resample \
		--disable-ilbc-codec \
		$(use_enable ssl )\
		$(use_enable alsa sound) \
		$(use_enable oss) \
		$(use_enable ext-sound) \
		$(use_enable g711 g711-codec) \
		$(use_enable l16 l16-codec) \
		$(use_enable g722 g722-codec) \
		$(use_enable g7221 g7221-codec) \
		$(usex speex '' '--disable-speex-codec --disable-speex-aec') \
		$(usex gsm '' '--disable-gsm-codec') \
		$(use_enable video) \
		$(usex video '--enable-ffmpeg --disable-libyuv' '--disable-ffmpeg') \
		--with-external-speex \
		--with-external-pa \
		--with-external-gsm \
		--with-external-srtp \
		--enable-shared
}

src_install() {
	DESTDIR="${D}" emake install

	if use cli; then
		newbin pjsip-apps/bin/pjsua* pjsua
	fi

	if use python; then
		pushd pjsip-apps/src/python
		python setup.py install --prefix="${D}/usr/"
		popd
	fi

	if use doc; then
		dodoc README.txt README-RTEMS
	fi

	if use examples; then
		docinto examples
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc pjsip-apps/src/samples/*
	fi
}
