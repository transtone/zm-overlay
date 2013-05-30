EAPI=4

inherit git-2 flag-o-matic

DESCRIPTION="A QQ client based on gtk+ uses WebQQ protocol."
HOMEPAGE="http://code.google.com/p/gtk-qq/ https://github.com/kernelhcy/gtkqq"
EGIT_REPO_URI="git://github.com/kernelhcy/gtkqq.git"
EGIT_BRANCH="dev"
EGIT_BOOTSTRAP="autogen.sh"

LICENSE="GPL-3"
KEYWORDS=""
SLOT="0"
IUSE="gtk3 gstreamer libnotify proxy"

RDEPEND="
dev-db/sqlite:3
sys-libs/zlib
gtk3? ( x11-libs/gtk+:3 )
!gtk3? ( x11-libs/gtk+:2 >=x11-libs/gtk+-2.24.0 )
gstreamer? ( >=media-libs/gstreamer-0.10 )
libnotify? ( x11-libs/libnotify )
"
DEPEND="${RDEPEND}"


src_configure() {
    strip-flags
   filter-flags -O*
   append-flags -O0
   econf \
      $(use_enable gtk3) \
      $(use_enable gstreamer) \
      $(use_enable libnotify) \
      $(use_enable proxy)
}
