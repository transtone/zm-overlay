# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-meta/gnome-meta-2.26.2.ebuild,v 1.1 2009/05/31 18:30:29 eva Exp $

S=${WORKDIR}
DESCRIPTION="Meta package for the GNOME desktop, merge this package to install"
HOMEPAGE="http://www.gnome.org/"
LICENSE="as-is"
SLOT="2.0"
IUSE=""

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~x86 ~x86-fbsd"

#  Note to developers:
#  This is a wrapper for the 'light' Gnome2 desktop,
#  This should only consist of the bare minimum of libs/apps needed
#  It is basicly the gnome-base/gnome without all extra apps

#  This is currently in it's test phase, if you feel like some dep
#  should be added or removed from this pack file a bug to
#  gnome@gentoo.org on bugs.gentoo.org

#	>=media-gfx/eog-2.26.2

RDEPEND="!gnome-base/gnome

	gnome-extra/gnome-power-manager
	>=gnome-base/gnome-desktop-2.26.2
	>=gnome-base/gnome-session-2.26.1
	>=gnome-base/gnome-panel-2.26.2
	>=x11-themes/gnome-icon-theme-2.26.0 "

pkg_postinst () {
# FIXME: Rephrase to teach about using different WMs instead, as metacity is the default anyway
# FIXME: but first check WINDOW_MANAGER is still honored in 2.24. gnome-session-2.24 might have lost
# FIXME: support for it, but we don't ship with gnome-session-2.24 yet
#	elog "Note that to change windowmanager to metacity do: "
#	elog " export WINDOW_MANAGER=\"/usr/bin/metacity\""
#	elog "of course this works for all other window managers as well"
#	elog

	elog "Use gnome-base/gnome for the full GNOME Desktop"
	elog "as released by the GNOME team."
}
