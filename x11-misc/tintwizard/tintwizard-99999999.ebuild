# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_DEPEND="2"

inherit python subversion

DESCRIPTION="GUI wizard which generates config files for tint2 panels"
HOMEPAGE="http://code.google.com/p/tintwizard/"
ESVN_REPO_URI="http://tintwizard.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/pygtk:2
	x11-misc/tint2"

DEPEND=""

src_prepare() {
	python_convert_shebangs 2 tintwizard.py
}

src_install() {
	dobin tintwizard.py || die
	dosym /usr/bin/tintwizard.py /usr/bin/tintwizard || die

	dodoc ChangeLog
}
