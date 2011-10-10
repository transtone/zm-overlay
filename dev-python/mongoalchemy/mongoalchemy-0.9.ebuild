# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlalchemy/sqlalchemy-0.7.2.ebuild,v 1.3 2011/09/11 20:11:25 maekke Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="MongoAlchemy"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Python Mongo toolkit and Object Relational Mapper"
HOMEPAGE="http://www.mongoalchemy.org/ http://pypi.python.org/pypi/MongoAlchemy"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples firebird mssql mysql postgres test"

RDEPEND="dev-python/setuptools
	firebird? ( dev-python/kinterbasdb )
	mssql? ( dev-python/pymssql )
	mysql? ( dev-python/mysql-python )
	postgres? ( >=dev-python/psycopg-2 )
	"
DEPEND="${RDEPEND}
	test? (
		>=dev-db/sqlite-3.3.13
		>=dev-python/nose-0.10.4
		|| ( >=dev-lang/python-2.5[sqlite] dev-python/pymongo )
	)"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

# In EAPI="4":
# DISTUTILS_GLOBAL_OPTIONS=("2.*-cpython --with-cextensions")
PYTHON_MODNAME="mongoalchemy"

src_prepare() {
	distutils_src_prepare

}

src_test() {
	distutils_src_test
}

src_install() {
	distutils_src_install

	if use doc; then
		pushd doc > /dev/null
		rm -fr build
		dohtml -r [a-z]* _images _static
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
