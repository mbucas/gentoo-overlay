# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
DESCRIPTION="FreeFileSync is a folder comparison and synchronization tool"
HOMEPAGE="http://sf.net/projects/freefilesync"
SRC_URI="mirror://sourceforge/${PN}/v${PV}/FreeFileSync_${PV}_source.zip"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="app-arch/unzip >=sys-devel/gcc-4.6"
RDEPEND="x11-libs/wxGTK dev-libs/boost"

src_unpack(){
	mkdir "${S}"
	cd "${S}"
	unpack "${A}"
}

src_compile(){
	emake || die "emake failed for FreeFileSync"
	cd RealtimeSync
	emake || die "emake failed for RealtimeSync"
}

src_install(){
	emake DESTDIR="${D}" install || die "Install failed for FreeFileSync"
	cd RealtimeSync
	emake DESTDIR="${D}" install || die "Install failed for RealtimeSync"
}
