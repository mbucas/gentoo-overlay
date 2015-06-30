# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WX_GTK_VER="3.0"
inherit wxwidgets

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="http://sf.net/projects/freefilesync"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${MY_PV}/FreeFileSync_${PV}_Source.zip"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	x11-libs/wxGTK:3.0[X]
	>=dev-libs/zenxml-2.1"

RDEPEND="x11-libs/wxGTK[X]
	dev-libs/boost"

S=${WORKDIR}

src_compile(){
    cd FreeFileSync/Source
    emake launchpad || die "emake failed for FreeFileSync"
    cd RealtimeSync
    emake launchpad || die "emake failed for RealtimeSync"
}

src_install(){
    cd FreeFileSync/Source
    emake DESTDIR="${D}" install || die "Install failed for FreeFileSync"
    cd RealtimeSync
    emake DESTDIR="${D}" install || die "Install failed for RealtimeSync"

    unzip ../../Build/Resources.zip FreeFileSync.png RealtimeSync.png

    newicon FreeFileSync.png FreeFileSync.png
    make_desktop_entry "FreeFileSync" "Synchronize files and folders" "FreeFileSync" "System;Utility"

    newicon RealtimeSync.png RealtimeSync.png
    make_desktop_entry "RealtimeSync" "Synchronize files and folders in realtime" "RealtimeSync" "System;Utility"
}
