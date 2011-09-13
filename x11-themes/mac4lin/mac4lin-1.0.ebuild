# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib font eutils gnome2-utils mount-boot autotools mozextension

DESCRIPTION="brings the Mac OS X user interface to GNU/Linux"
HOMEPAGE="http://sourceforge.net/projects/mac4lin"
SRC_URI="mirror://sourceforge/${PN}/Mac4Lin_v${PV}.tar.gz
	mirror://sourceforge/${PN}/Leopard_Wallpapers.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk icons sounds cursors emerald pidgin backgrounds fonts gdm -grub awn"

DEPEND=""
RDEPEND="gtk? ( x11-libs/gtk+ )
		cursors? ( x11-base/xorg-server )
		emerald? ( x11-wm/emerald )
		pidgin? ( net-im/pidgin )
		fonts? ( media-fonts/corefonts )
		gdm? ( gnome-base/gdm )
		awn? ( gnome-extra/avant-window-navigator )
		grub? ( x11-themes/mac4lin-grub )"
RESTRICT="binchecks strip"

S=${WORKDIR}

src_install() {
	cd "${S}/Mac4Lin_Install_v1.0"

	THEMES_PATH="/usr/share/themes/"
	ICONS_PATH="/usr/share/icons/"
	CURSORS_PATH=${ICONS_PATH}
	SOUNDS_PATH="/usr/share/sounds/"
	EMERALD_PATH="/usr/share/emerald/themes/"
	PIDGIN_PLUGINS_PATH="/usr/lib/purple-2/"
	PIXMAPS_PATH="/usr/share/pixmaps/"
	BACKGROUNDS_PATH="/usr/share/backgrounds/"
	FONTS_PATH="/usr/share/fonts/"
	GDM_PATH="/usr/share/gdm/themes/"
	AWN_PATH="/usr/share/avant-window-navigator/themes/"

	if use gtk ; then
		dodir $THEMES_PATH

		tar \
			-xzf GTK/Mac4Lin_GTK_Aqua_v${PV}.tar.gz \
			-C ${D}$THEMES_PATH

		tar \
			-xzf GTK/Mac4Lin_GTK_Graphite_v${PV}.tar.gz \
			-C ${D}$THEMES_PATH

		tar \
			-xzf GTK/Mac4Lin_Meta_v${PV}.tar.gz \
			-C ${D}$THEMES_PATH
	fi

	if use icons ; then
		dodir $ICONS_PATH
		
		tar \
			-xzf Icons/Mac4Lin_Icons_v${PV}.tar.gz \
			-C ${D}$ICONS_PATH \
			|| die "installing icons failed"
	fi

	if use cursors ; then
		dodir $CURSORS_PATH

		tar \
			-xzf Cursor/Mac4Lin_Cursors_v${PV}.tar.gz \
			-C ${D}$CURSORS_PATH \
			|| die "installing cursors failed"
	fi

	if use sounds ; then
		dodir $SOUNDS_PATH

		tar \
			-xzf Sounds/Mac4Lin_Sounds_v${PV}.tar.gz \
			-C ${D}$SOUNDS_PATH \
			|| die "installing sounds failed"
	fi

	if use emerald ; then
		dodir $EMERALD_PATH
		
		tar \
			-xzf Emerald/Mac4Lin_Emerald_Graphite_v${PV}.tar.gz \
			-C ${D}$EMERALD_PATH
		tar \
			-xzf Emerald/Mac4Lin_Emerald_Aqua_v${PV}.tar.gz \
			-C ${D}$EMERALD_PATH
	fi

	if use pidgin ; then
		if use awn ; then
			dodir $PIDGIN_PLUGINS_PATH

			cp AWN/Plugins/Pidgin_AWN_32bit/pidgin_awn.so ${D}$PIDGIN_PLUGINS_PATH
		fi

		if use sounds ; then
			dodir $SOUNDS_PATH

			tar \
				-xzf Sounds/Mac4Lin_Pidgin-Sounds_v${PV}.tar.gz \
				-C ${D}$SOUNDS_PATH \
				|| die "installing pidgin's sounds failed"
		fi

		dodir $PIXMAPS_PATH

		tar \
			-xzf Pidgin/Mac4Lin_Pidgin_v${PV}.tar.gz \
			-C ${D}$PIXMAPS_PATH \
			|| die "installing pidgin's icons failed"
	fi

	if use backgrounds ; then
		dodir $BACKGROUNDS_PATH

		cp Wallpapers/*.* ${D}$BACKGROUNDS_PATH
	fi

	if use fonts ; then
		dodir $FONTS_PATH
		
		mkdir -p ${D}$FONTS_PATH${PN}
		tar \
			-xzf Fonts/fonts.tar.gz \
			-C	${D}$FONTS_PATH${PN} \
			|| die "installing fonts failed"

		cd ${D}$FONTS_PATH${PN}
		font_xfont_config
		font_xft_config
		font_fontconfig
		cd "${S}/Mac4Lin_Install_v${PV}"
	fi
	
	if use gdm ; then
		dodir $GDM_PATH

		tar \
			-xzf GDM/Mac4Lin_GDM_v${PV}.tar.gz \
			-C ${D}$GDM_PATH \
			|| die "installing gdm theme failed"
	fi

	if use awn ; then
		dodir $AWN_PATH
		
		tar \
			-xzf AWN/Mac4Lin_AWN_v${PV}.tgz \
			-C ${D}$AWN_PATH
	fi

	chown -R root:root ${D}

	find ${D} -type f -perm -o+w -exec chmod 655 {} \;

	find ${D} -perm -g=- -exec chmod g=rx {} \;
	find ${D} -perm -o=- -exec chmod o=rx {} \;
}

