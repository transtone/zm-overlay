# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit gst-plugins-bad

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/gstreamer-0.10.18
	>=media-libs/gst-plugins-base-0.10.18"
DEPEND="${RDEPEND}
	virtual/os-headers"
