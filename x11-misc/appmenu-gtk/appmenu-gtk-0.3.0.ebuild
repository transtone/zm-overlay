# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

DESCRIPTION="Application menu module for GTK"
HOMEPAGE="https://launchpad.net/appmenu-gtk"
SRC_URI="http://launchpad.net/${PN}/0.3/${PV}/+download/${PN}-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86"
IUSE="+gtk2 gtk3"

CDEPEND=""
DEPEND=">=dev-libs/libdbusmenu-0.4.2[gtk]
		gtk3? ( >=dev-libs/libdbusmenu-0.4.2[gtk3] )
		>=x11-libs/gtk+-2.24.6[appmenu]"
RDEPEND="${DEPEND}"
src_prepare(){
epatch ${FILESDIR}/fix.patch
}

src_configure(){
  if use gtk2;then
	econf --with-gtk2
  fi

  if use gtk3;then
	mkdir gtk3-hack
	cp -R * gtk3-hack
	cd gtk3-hack
	econf 
  fi
}
src_compile(){
  if use gtk2;then
  emake
  fi 
  
  if use gtk3;then
  cd gtk3-hack
  emake
  fi
}
src_install(){
  if use gtk2;then
	insinto /usr/lib/gtk-2.0/2.10.0/menuproxies/
	doins src/.libs/libappmenu.so
  fi
  
  if use gtk3;then
    insinto /usr/lib/gtk-3.0/3.0.0/menuproxies
	doins gtk3-hack/src/.libs/libappmenu.so
  fi
  mv 80appmenu appmenu.sh
  insinto /etc/profile.d/
  doins appmenu.sh
}
