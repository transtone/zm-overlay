# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

VIM_PLUGIN_VIM_VERSION="7.0"
inherit git vim-plugin

DESCRIPTION="vim plugin: TextMate-style snippets"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2540"
SRC_URI=""
EGIT_REPO_URI="git://github.com/msanders/snipmate.vim.git"

LICENSE="as-is"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"

VIM_PLUGIN_HELPFILES="${PN}"
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES="filetype"

