# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WX_GTK_VER="3.0"
inherit wxwidgets

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="https://www.freefilesync.org/ http://sourceforge.net/projects/freefilesync/"
SRC_URI="http://download1467.mediafire.com/br8850dt44ng/j7gua6als1wec9u/FreeFileSync_8.4_Source.zip http://www.freefilesync.org/archive/FreeFileSync_${PV}_Source.zip"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	x11-libs/wxGTK:3.0[X]
	>=dev-libs/zenxml-2.3"

RDEPEND="x11-libs/wxGTK[X]
	dev-libs/boost"

S=${WORKDIR}

src_compile(){
    cd FreeFileSync/Source
    sed -i 's/-lboost_system/-lboost_system -lboost_chrono -lrt/' Makefile
    sed -i 's|CPP_LIST+=ui/check_version.cpp|CPP_LIST+=ui/version_check.cpp|' Makefile
    sed -i 's|-std=c++11|-std=c++14|' Makefile
    sed -i 's|../Build/Sync_Complete.wav|../Build/ding.wav ../Build/gong.wav ../Build/harp.wav|' Makefile
    sed -i '/	..\/Build\/styles.gtk_rc \\/d' Makefile
    emake launchpad || die "emake failed for FreeFileSync"
    cd RealTimeSync
    sed -i 's/-lboost_system/-lboost_system -lboost_chrono -lrt/' Makefile
    sed -i 's|-std=c++11|-std=c++14|' Makefile
    emake launchpad || die "emake failed for RealTimeSync"
}

src_install(){
    cd FreeFileSync/Source
    emake DESTDIR="${D}" install || die "Install failed for FreeFileSync"
    cd RealTimeSync
    emake DESTDIR="${D}" install || die "Install failed for RealTimeSync"

    unzip ../../Build/Resources.zip FreeFileSync.png RealTimeSync.png

    newicon FreeFileSync.png FreeFileSync.png
    make_desktop_entry "FreeFileSync" "Synchronize files and folders" "FreeFileSync" "System;Utility"

    newicon RealTimeSync.png RealTimeSync.png
    make_desktop_entry "RealTimeSync" "Synchronize files and folders in realtime" "RealTimeSync" "System;Utility"
}
