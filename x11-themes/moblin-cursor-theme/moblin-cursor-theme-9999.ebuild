# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools git

DESCRIPTION="Mobline cursor theme"
HOMEPAGE="http://repo.or.cz/r/moblin-cursor-theme.git"
SRC_URI=""
EGIT_REPO_URI="git://repo.or.cz/moblin-cursor-theme.git"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
x11-apps/xcursorgen"

src_compile() {
	cd pngs && ./make.sh
}

src_install() {
	cd "${S}"
	insinto /usr/share/cursors/xorg-x11/${PN}
	doins -r xcursors
}

pkg_postinst() {
	elog "To use this set of cursors, edit or create the file ~/.Xdefaults"
	elog "and add the following line:"
	elog "Xcursor.theme: ${PN}"
	elog
	elog "You can change the size by adding a line like:"
	elog "Xcursor.size: 48"
	elog
	elog "Also, to globally use this set of mouse cursors edit the file:"
	elog "    /usr/share/cursors/xorg-x11/default/index.theme"
	elog "and change the line:"
	elog "    Inherits=[current setting]"
	elog "to"
	elog "    Inherits=${PN}"
	elog
	elog "Note this will be overruled by a user's ~/.Xdefaults file."
	elog
	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option  \"HWCursor\"  \"false\""
}
