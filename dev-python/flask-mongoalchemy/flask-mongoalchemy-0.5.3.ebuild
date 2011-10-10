# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-mongoalchemy/flask-mongoalchemy-0.5.3.ebuild,v 1.1 2011/09/08 07:03:16 transtone Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils

MY_PN="Flask-MongoAlchemy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="MongoAlchemy support for Flask applications"
HOMEPAGE="http://packages.python.org/Flask-MongoAlchemy/ https://github.com/cobrateam/flask-mongoalchemy http://pypi.python.org/pypi/Flask-MongoAlchemy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/flask
		 >=dev-python/mongoalchemy-0.9
		 >=dev-python/pymongo-1.10.1
		 dev-python/setuptools"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="flaskext/mongoalchemy/meta.py"
