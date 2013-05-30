# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xpyb/xpyb-1.3.1-r1.ebuild,v 1.4 2013/03/23 21:40:16 ago Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} )
inherit distutils-r1 git-2

EGIT_REPO_URI="git://github.com/BurntSushi/pytyle3.git"
#SRC_URI=""
DESCRIPTION="PyTyle is an on-demand automatic and manual tiling manager"
HOMEPAGE="https://github.com/BurntSushi/pytyle3"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
LICENSE="GPL-2 LGPL-3"
SLOT="0"
IUSE="doc examples"

RDEPEND="x11-libs/xpybutil
		 ${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

python_install_all() {
		use doc && local HTML_DOCS=( docs/_build/html/. )

		distutils-r1_python_install_all

		if use examples; then
				insinto /usr/share/doc/${PF}
				doins -r examples
		fi
}
