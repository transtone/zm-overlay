# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
K_DEBLOB_AVAILABLE="1"

ck_version="1"
gentoo_version="17"
optimization_version="2"
tuxonice_version="2013.08.30"
uksm_version="0.1.2.2"

aufs_kernel_version="3.10_p20130821"
cjktty_kernel_version="3.8.1"
reiser4_kernel_version="3.10.0"
tuxonice_kernel_version="3.10.10"
uksm_kernel_version="3.10.0"

KEYWORDS="~amd64 ~x86"

SUPPORTED_USE="+aufs +cjktty +ck +gentoo +optimization +reiser4 +tuxonice +uksm"

CK_PRE_PATCH=""
CK_POST_PATCH=""
UNIPATCH_EXCLUDE=""

OVERRIDE_CJKTTY_PATCHES="0"
OVERRIDE_CK_PATCHES="0"
OVERRIDE_FBCONDECOR_PATCHES="0"
OVERRIDE_REISER4_PATCHES="0"
OVERRIDE_TUXONICE_PATCHES="0"
OVERRIDE_UKSM_PATCHES="0"

ADDITION_PATCHES="${FILESDIR}/enable-thinkpad-hardware-mute-control.patch"

inherit e-sources
