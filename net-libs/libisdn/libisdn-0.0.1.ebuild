#
# Copyright (C) 2012 Stefan Knoblich <stkn@openisdn.net>
#
# Distributed under the terms of the GNU General Public License 2
# see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt for
# more information
#

EAPI="4"

IUSE="doc static-libs"

if [[ "${PV}" = "9999" ]]
then
	EGIT_REPO_URI="http://git.openisdn.net/libisdn.git/"
	EGIT_BOOTSTRAP="./autogen.sh"
	SCM="git-2"
else
	SRC_URI="http://files.openisdn.net/nightly/source/${P}.tar.bz2"
fi

inherit flag-o-matic ${SCM}

DESCRIPTION="ISDN (Q.931; PRI/BRI) protocol stack"
HOMEPAGE="http://www.openisdn.net/"

SLOT="0"

LICENSE="BSD"
KEYWORDS=""

DOCS=( "${S}/CREDITS" "${S}/TODO" )

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.61
	>=sys-devel/automake-1.10
	doc? ( app-doc/doxygen )"

src_configure() {
	local myconf=""

	econf \
		$(use_enable static-libs static) \
		${myconf} || die "econf failed"
}

src_compile() {
	emake || die "emake failed"

	if use doc ; then
		einfo "Building API documentation..."
		emake doxygen || die "building API docs failed"
	fi
}

src_install() {
	default_src_install

	if use doc ; then
		einfo "Installing ${PN} API documentation into \"${ROOT}usr/share/doc/${PVF}/html\""
		dohtml -r docs/html/
	fi
}
