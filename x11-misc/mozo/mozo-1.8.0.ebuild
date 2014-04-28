# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_REQ_USE="xml"
SUPPORT_PYTHON_ABIS="1"

inherit mate python-r1

DESCRIPTION="Mozo menu editor for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

COMMON_DEPEND="dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=mate-base/mate-menus-1.2.0[introspection,python]"

	# mate-panel needed for mate-desktop-item-edit
RDEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=mate-base/mate-panel-1.7.0
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:2[introspection]"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
	!!x11-misc/mate-menu-editor"

src_prepare() {
	gnome2_src_prepare
	python_copy_sources
}

src_configure() {
	DOCS="AUTHORS NEWS README"

	python_foreach_impl run_in_build_dir \
		gnome2_src_configure --disable-icon-update
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir emake check
}

src_install() {
	installing() {
		gnome2_src_install
		# Massage shebang to make python_doscript happy
		sed -e 's:#! '"${PYTHON}:#!/usr/bin/python:" \
			-i mozo || die
			python_doscript mozo
		}
	python_foreach_impl run_in_build_dir installing
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null || die
	"$@"
	popd > /dev/null
}
