# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1 git-2

DESCRIPTION="adds flavor of interactive filtering to the traditional pipe concept of UNIX shell"
HOMEPAGE="https://github.com/mooz/percol"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mooz/percol.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PYTHON_MODNAME="percol"
