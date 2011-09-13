# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/stoneapps-meta/stoneapps-meta-0.1.ebuild,v 1.0 2011/06/01 12:30:00 transtone Exp $

DESCRIPTION="Transtone's meta ebuild for sys-apps"
HOMEPAGE="http://transtone.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc x86"
IUSE=""

RDEPEND="sys-apps/ack
sys-apps/dog
sys-apps/dstat
sys-apps/fakeroot
sys-apps/iproute2
sys-apps/logwatch
sys-apps/lshw
sys-apps/mlocate
sys-apps/usermode-utilities
sys-block/ms-sys
sys-boot/grub
sys-devel/bc
sys-fs/btrfs-progs
sys-fs/diskdev_cmds
sys-fs/dosfstools
sys-fs/extundelete
sys-fs/lvm2
sys-fs/ncdu
sys-fs/ntfs3g
sys-fs/xfsprogs
sys-kernel/genkernel
sys-kernel/module-rebuild
sys-libs/libstdc++-v3
sys-power/powertop
sys-process/fcron
sys-process/htop
sys-process/iotop
sys-process/schedtool
app-admin/conky
app-admin/logrotate
app-admin/pydf
app-admin/sudo
app-arch/atool
app-arch/dpkg
app-arch/file-roller
app-arch/p7zip
app-cdr/cdw
app-editors/emacs
app-editors/gvim
media-gfx/fbv
dev-util/lafilefixer
net-analyzer/macchanger
net-analyzer/bmon"

