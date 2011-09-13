# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/csslayer/fcitx-cloudpinyin.git"
inherit cmake-utils git-2

DESCRIPTION="Cloud Pinyin for Fcitx"
HOMEPAGE="https://github.com/csslayer/fcitx-cloudpinyin"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=app-i18n/fcitx-${PV}"
RDEPEND="${DEPEND}"
