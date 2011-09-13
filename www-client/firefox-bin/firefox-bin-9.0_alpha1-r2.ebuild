# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils mozilla-launcher multilib mozextension pax-utils

MY_PV="${PV/_alpha/a}"
MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Firefox Web Browser"
KEYWORDS=""

FDATE="2011-09-07-03-08-53"
SRC_URI=" http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/${FDATE}-mozilla-central-l10n/${MY_P}.zh-CN.linux-x86_64.tar.bz2 -> ${MY_PN}_${FDATE}-x86_64.tar.bz2 "
HOMEPAGE="http://www.mozilla.com/firefox"
RESTRICT="strip mirror"

SLOT="0"
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
IUSE="default-icons startup-notification"

DEPEND="app-arch/unzip"
RDEPEND="dev-libs/dbus-glib
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXmu

	>=x11-libs/gtk+-2.2:2
	>=media-libs/alsa-lib-1.0.16
"

S="${WORKDIR}/${MY_PN}"

src_install() {
	declare MOZILLA_FIVE_HOME=/opt/${MY_PN}

	# Install icon and .desktop for menu entry
	newicon "${FILESDIR}"/chrome/default48.png ${PN}-icon.png
	domenu "${FILESDIR}"/${PN}.desktop

	# Add StartupNotify=true bug 237317
	if use startup-notification; then
		echo "StartupNotify=true" >> "${D}"/usr/share/applications/${PN}.desktop
	fi

	# Install firefox in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${D}"${MOZILLA_FIVE_HOME} || die

	if use !default-icons; then
		cp "${FILESDIR}"/chrome/* "${D}""${MOZILLA_FIVE_HOME}"/chrome/icons/default/
		cp "${FILESDIR}"/icons/* "${D}""${MOZILLA_FIVE_HOME}"/icons/
	fi

	# Fix prefs that make no sense for a system-wide install
	insinto ${MOZILLA_FIVE_HOME}/defaults/pref/
	doins "${FILESDIR}"/${PN}-prefs.js || die

	# Create /usr/bin/firefox-bin
	dodir /usr/bin/
	cat <<-EOF >"${D}"/usr/bin/${PN}
	#!/bin/sh
	unset LD_PRELOAD
	LD_LIBRARY_PATH="/opt/firefox/"
	GTK_PATH=/usr/lib/gtk-2.0/
	exec /opt/${MY_PN}/${MY_PN} "\$@"
	EOF
	fperms 0755 /usr/bin/${PN}

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/10${PN} || die

	ln -sfn "/usr/$(get_libdir)/nsbrowser/plugins" \
			"${D}${MOZILLA_FIVE_HOME}/plugins" || die

	pax-mark -mr "${D}${MOZILLA_FIVE_HOME}"/crashreporter
	pax-mark -mr "${D}${MOZILLA_FIVE_HOME}"/firefox
	pax-mark -mr "${D}${MOZILLA_FIVE_HOME}"/firefox-bin
	pax-mark -mr "${D}${MOZILLA_FIVE_HOME}"/plugin-container
	pax-mark -mr "${D}${MOZILLA_FIVE_HOME}"/updater
}

pkg_postinst() {
	if ! has_version 'gnome-base/gconf' || ! has_version 'gnome-base/orbit' \
		|| ! has_version 'net-misc/curl'; then
		einfo
		einfo "For using the crashreporter, you need gnome-base/gconf,"
		einfo "gnome-base/orbit and net-misc/curl emerged."
		einfo
	fi
	if has_version 'net-misc/curl[nss]'; then
		einfo
		einfo "Crashreporter won't be able to send reports"
		einfo "if you have curl emerged with the nss USE-flag"
		einfo
	fi
}

pkg_postrm() {
	update_mozilla_launcher_symlinks
}
