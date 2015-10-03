# Copyright 1999-2012 Gentoo Foundation 
# Distributed under the terms of the GNU General Public License v2 
# $Header: $ 
EAPI="4" 

inherit eutils toolchain-funcs 

MY_P="zenXml" 

DESCRIPTION="Zen XML header c++ library" 
HOMEPAGE="" 
SRC_URI="mirror://sourceforge/project/${PN}/${MY_P}_${PV}.zip" 

LICENSE="GPL" 
SLOT="0" 
KEYWORDS="~amd64 ~x86" 

RDEPEND=""

S="${WORKDIR}"

src_install(){ 
        insinto /usr/include/
        doins -r "${S}/zen/" || die "Install zen header files failed!" 
        doins -r "${S}/zenxml/" || die "Install zenxml header files failed!" 
}

