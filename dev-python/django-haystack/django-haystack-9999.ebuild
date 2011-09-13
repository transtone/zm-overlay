# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND=2
RESTRICT_PYTHON_ABIS="3.*"

inherit git distutils python

DESCRIPTION="Modular search for django"
HOMEPAGE="http://haystacksearch.org"
EGIT_REPO_URI="git://github.com/toastdriven/django-haystack.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django
	>=dev-python/Whoosh-0.3"

S=${WORKDIR}/${PN}
