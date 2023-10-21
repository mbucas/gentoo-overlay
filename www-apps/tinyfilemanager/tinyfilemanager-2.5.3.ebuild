# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Single-file PHP file manager"
HOMEPAGE="https://tinyfilemanager.github.io/"
SRC_URI="https://github.com/prasathmani/tinyfilemanager/archive/refs/tags/${PV}.tar.gz"
LICENSE="GPL-3"

KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
    || ( 
        ( virtual/httpd-php:8.0 dev-lang/php:8.0 )
        ( virtual/httpd-php:8.1 dev-lang/php:8.1 )
    )
	dev-lang/php[fileinfo,iconv,zip]
"

S="${WORKDIR}/${P}"

PATCHES=(
	"${FILESDIR}"/tinyfilemanager-${PV}-personal-changes.patch
)

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	newins tinyfilemanager.php index.php
	doins translation.json
    doins -r assets
    # Missing dark theme asset
    insinto "${MY_HTDOCSDIR}"/assets/css
    newins "${FILESDIR}"/ir-black.min.css ir-black.min.css

	webapp_serverowned "${MY_HTDOCSDIR}"
	webapp_serverowned "${MY_HTDOCSDIR}"/index.php
	webapp_serverowned "${MY_HTDOCSDIR}"/translation.json
	webapp_serverowned -R "${MY_HTDOCSDIR}"/assets

	webapp_src_install
}
