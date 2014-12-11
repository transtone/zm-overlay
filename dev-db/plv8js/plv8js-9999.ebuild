# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="PL/V8 Javascript for PostgreSQL"
HOMEPAGE="https://code.google.com/p/plv8js/"
SRC_URI=""

EGIT_REPO_URI="https://code.google.com/p/plv8js/"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	=dev-lang/v8-3.18.5.14
	>=dev-db/postgresql-server-9.2"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}
