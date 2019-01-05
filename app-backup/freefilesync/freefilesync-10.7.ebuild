# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WX_GTK_VER="3.1"
inherit eutils wxwidgets

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="https://www.freefilesync.org/ http://sourceforge.net/projects/freefilesync/"

# Now uses xBRZ, from the same author
# https://sourceforge.net/projects/xbrz/
# The Zip doesn't contain a Makefile, so I just included it here
SRC_URI="
    http://www.freefilesync.org/download/FreeFileSync_${PV}_Source.zip
"
RESTRICT="mirror"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	>=x11-libs/wxGTK-3.1[X]
	>=dev-libs/zenxml-2.4"

RDEPEND="x11-libs/wxGTK[X]
	dev-libs/boost"

S=${WORKDIR}

src_prepare(){
    cd "${S}"
    find . -name '*.cpp' -o -name '*.h' |xargs sed -i 's/\r//'
    epatch "${FILESDIR}"/freefilesync-${PV}-std-byte-resources-path.patch
}

src_compile(){
    cd FreeFileSync/Source
    sed -i 's|LINKFLAGS = -s|LINKFLAGS =|' Makefile
    sed -i 's|gtk+-2.0|gtk+-3.0|' Makefile
    sed -i 's|-isystem../../boost ||' Makefile
    sed -i 's|-pipe|-pipe -DZEN_LINUX|' Makefile
    sed -i 's|-no-pie|-no-pie -lz|' Makefile
    sed -i 's|../Build/Changelog.txt|../../Changelog.txt|' Makefile
    sed -i 's|gzip|#gzip|' Makefile
    mkdir ../Build/Bin
    emake || die "emake failed for FreeFileSync"
    cd RealTimeSync
    sed -i 's|LINKFLAGS = -s|LINKFLAGS =|' Makefile
    sed -i 's|gtk+-2.0|gtk+-3.0|' Makefile
    sed -i 's|-isystem../../boost ||' Makefile
    sed -i 's|-pipe|-pipe -DZEN_LINUX|' Makefile
    sed -i 's|-no-pie|-no-pie -lz|' Makefile
    emake || die "emake failed for RealTimeSync"
}

src_install(){
    cd FreeFileSync/Source
    sed -i '/User Manual.pdf/d' Makefile
    emake DESTDIR="${D}" install || die "Install failed for FreeFileSync"
    cd RealTimeSync
    emake DESTDIR="${D}" install || die "Install failed for RealTimeSync"

    unzip ../../Build/Resources.zip FreeFileSync.png RealTimeSync.png

    newicon FreeFileSync.png FreeFileSync.png
    make_desktop_entry "FreeFileSync" "Synchronize files and folders" "FreeFileSync" "System;Utility"

    newicon RealTimeSync.png RealTimeSync.png
    make_desktop_entry "RealTimeSync" "Synchronize files and folders in realtime" "RealTimeSync" "System;Utility"
    
    # Correct FHS/Gentoo policy paths
    mv ${D}/usr/share/doc/FreeFileSync ${D}/usr/share/doc/${PF}
}
