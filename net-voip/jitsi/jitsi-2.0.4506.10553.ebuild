# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2 java-ant-2 eutils multilib

DESCRIPTION="An audio/video SIP VoIP phone and instant messenger written in Java"
HOMEPAGE="http://www.jitsi.org/"
SRC_URI="https://download.jitsi.org/jitsi/src/${PN}-src-${PV}.zip"
# this download comes with 30 Mb of useless jars
# svn access is available but requires an account at java.net


LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.6"
DEPEND=">=virtual/jdk-1.6
		dev-java/xalan:0
		dev-java/ant-nodeps:0"

S="${WORKDIR}/${PN}"

EANT_BUILD_TARGET="rebuild"

src_install() {
	insinto "/usr/$(get_libdir)/jitsi/sc-bundles"
	doins sc-bundles/*.jar sc-bundles/os-specific/linux/*.jar

	insinto "/usr/$(get_libdir)/jitsi/lib"
	doins lib/* lib/os-specific/linux/*
	doins -r lib/bundle

	insinto "/usr/$(get_libdir)/jitsi/lib/native"
	# WARNING: foreign binaries
	if [[ "${ARCH}" = amd64 ]]; then
		doins lib/native/linux-64/*
	else
		doins lib/native/linux/*
	fi

	insinto /usr/share/pixmaps
	doins resources/install/debian/sip-communicator.svg
	#newins resources/install/debian/sip-communicator-32.xpm sip-communicator.xpm
	make_desktop_entry jitsi Jitsi sip-communicator \
	"AudioVideo;Network;InstantMessaging;Chat;Telephony;VideoConference;Java;"

	sed -e 's/_PACKAGE_NAME_/jitsi/g' -e 's/_APP_NAME_/Jitsi/g' \
		resources/install/debian/sip-communicator.1.tmpl > jitsi.1 ||die
	doman jitsi.1

	libjawt_path="\\\$(java-config -o)/jre/lib"
	if [[ "${ARCH}" = amd64 ]]; then
		libjawt_path="${libjawt_path}/amd64"
	else
		libjawt_path="${libjawt_path}/i386"
	fi
	sed -e 's/_PACKAGE_NAME_/jitsi/g' \
		-e 's/javabin=.*/javabin=\$(java-config -J)/' \
		-e "s|LD_LIBRARY_PATH=|LD_LIBRARY_PATH=${libjawt_path}:|" \
		resources/install/debian/sip-communicator.sh.tmpl > jitsi || die
	dobin jitsi
	echo "SEARCH_DIRS_MASK=${EPREFIX}/usr/$(get_libdir)/jitsi/lib/native" \
		> 50-"${PN}"
	insinto /etc/revdep-rebuild && doins "50-${PN}"
}
