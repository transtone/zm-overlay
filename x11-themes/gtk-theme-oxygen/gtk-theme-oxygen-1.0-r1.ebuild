# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="KDE4 Oxygen new port for GNOME"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=86653"
SRC_URI="http://blog.kims-area.com/gnome/kde4-oxygen.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-themes/gtk-engines-murrine
	x11-themes/gtk-engines"

DEPEND=""

src_install() {
	insinto /usr/share/themes
	doins -r ./kde4-oxygen || die "doins failed."
}
