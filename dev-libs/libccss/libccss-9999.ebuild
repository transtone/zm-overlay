# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit git autotools eutils

DESCRIPTION="Cairo CSS Drawing Library"
HOMEPAGE="http://www.gtk.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/ccss"
EGIT_PROJECT="ccss"
EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12
	dev-util/gtk-doc
	net-libs/libsoup"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.31
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {

	local myconf

	myconf="
		--disable-examples
	"

	econf ${myconf}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	#dodoc FAQ NEWS README || die
	#dohtml EXTENDING.html ctags.html
}
