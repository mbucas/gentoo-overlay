# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WX_GTK_VER="2.9"
inherit wxwidgets

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="http://sf.net/projects/freefilesync"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/v${PV}/FreeFileSync_${PV}_Source.zip"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip >=sys-devel/gcc-4.7 x11-libs/wxGTK:2.9[X]"
RDEPEND=">=x11-libs/wxGTK-2.9.5[X] dev-libs/boost"

S=${WORKDIR}

src_compile(){
	cd FreeFileSync/Source
	emake BUILD=Launchpad || die "emake failed for FreeFileSync"
	cd RealtimeSync
	emake BUILD=Launchpad || die "emake failed for RealtimeSync"
}

src_install(){
	cd FreeFileSync/Source
	emake DESTDIR="${D}" install || die "Install failed for FreeFileSync"
	cd RealtimeSync
	emake DESTDIR="${D}" install || die "Install failed for RealtimeSync"
	
	make_desktop_entry /usr/bin/FreeFileSync FreeFileSync /usr/share/FreeFileSync/Help/img/ffsicon.png Utility;
}
