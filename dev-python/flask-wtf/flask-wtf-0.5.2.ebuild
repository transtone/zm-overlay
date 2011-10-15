# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-mongoalchemy/flask-mongoalchemy-0.5.3.ebuild,v 1.1 2011/09/08 07:03:16 transtone Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils

MY_PN="Flask-WTF"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple integration of Flask and WTForms, including CSRF, file upload and Recaptcha integration."
HOMEPAGE="http://packages.python.org/Flask-WTF/ https://bitbucket.org/danjac/flask-wtf http://pypi.python.org/pypi/Flask-WTF"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/flask
		 dev-python/wtforms"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="flaskext/wtf/file.py flaskext/wtf/html5.py flaskext/wtf/recaptcha/fields.py flaskext/wtf/recaptcha/widgets.py flaskext/wtf/recaptcha/validators.py"
