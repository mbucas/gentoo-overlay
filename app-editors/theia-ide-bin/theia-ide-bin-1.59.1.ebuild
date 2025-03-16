# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="The Theia IDE is a standard IDE built on the Theia Platform"
HOMEPAGE="https://theia-ide.org/"
SRC_URI="https://download.eclipse.org/theia/ide/${PV}/linux/TheiaIDE.deb -> TheiaIDE-${PV}.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Based on "control" from deb package
RDEPEND="
    x11-libs/gtk+:3=
    x11-libs/libnotify
    dev-libs/nss
    x11-libs/libXtst
    x11-misc/xdg-utils
    app-accessibility/at-spi2-core
    sys-apps/util-linux
    app-crypt/libsecret
"

S=${WORKDIR}

src_install() {
    # Copy contents
    cp -R "${S}/opt/" "${S}/usr/" "${D}/" || die "Copy failed"
    # Adjust doc path
    mv "${D}/usr/share/doc/theia-ide-electron-app" "${D}/usr/share/doc/${PF}" || die "Rename failed"
    # Application symbolic link
    dosym "../../opt/TheiaIDE/theia-ide-electron-app" "/usr/bin/theia-ide-electron-app"
}
