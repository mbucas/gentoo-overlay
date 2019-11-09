# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

WX_GTK_VER="3.1"
inherit desktop wxwidgets

DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="https://www.freefilesync.org/ http://sourceforge.net/projects/freefilesync/"

SRC_URI="
    http://www.freefilesync.org/download/FreeFileSync_${PV}_Source.zip
"
RESTRICT="mirror"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
    app-arch/unzip
	>=x11-libs/wxGTK-3.1[X]
	>=dev-libs/openssl-1.1
    net-misc/curl
    net-libs/libssh2
"

RDEPEND="x11-libs/wxGTK[X]"

PATCHES=(
    "${FILESDIR}"/freefilesync-${PV}-std-byte-resources-path.patch
    "${FILESDIR}"/freefilesync-${PV}-makefiles.patch
)

S=${WORKDIR}

src_prepare(){
    cd "${S}"
    mkdir FreeFileSync/Build/Bin
    find . -name '*.cpp' -o -name '*.h' |xargs sed -i 's/\r//'
    default
}

src_compile(){
    cd FreeFileSync/Source
    emake || die "emake failed for FreeFileSync"

    cd RealTimeSync
    emake || die "emake failed for RealTimeSync"
}

src_install(){
    cd FreeFileSync/Source
    emake DESTDIR="${D}" install || die "Install failed for FreeFileSync"
    cd RealTimeSync
    emake DESTDIR="${D}" install || die "Install failed for RealTimeSync"

    cd ../../Build/Misc
    newicon FreeFileSync.png FreeFileSync.png
    make_desktop_entry "FreeFileSync" "Synchronize files and folders" "FreeFileSync" "System;Utility"
    newicon RealTimeSync.png RealTimeSync.png
    make_desktop_entry "RealTimeSync" "Synchronize files and folders in realtime" "RealTimeSync" "System;Utility"
    
    # Correct FHS/Gentoo policy paths
    mv ${D}/usr/share/doc/FreeFileSync ${D}/usr/share/doc/${PF}
}
