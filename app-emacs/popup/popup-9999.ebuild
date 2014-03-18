# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/auto-complete/auto-complete-1.3.1.ebuild,v 1.2 2014/02/27 17:49:50 ulm Exp $

EAPI=5

inherit elisp git-2

DESCRIPTION="Auto-complete package"
HOMEPAGE="http://auto-complete.ort
          https://github.com/auto-complete/popup-el"
SRC_URI=""
EGIT_REPO_URI="https://github.com/auto-complete/popup-el"

LICENSE="GPL-3+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	# install dictionaries
	insinto "${SITEETC}/${PN}"

}
