# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Single-file PHP file manager"
HOMEPAGE="https://tinyfilemanager.github.io/"
SRC_URI="https://github.com/prasathmani/tinyfilemanager/archive/refs/tags/${PV}.tar.gz -> ${PN}.${PV}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="GPL-3"

KEYWORDS="~amd64"

RDEPEND="
	virtual/httpd-php:8.2
	dev-lang/php:8.2
	dev-lang/php[fileinfo,iconv,zip]
"

PATCHES=(
	"${FILESDIR}"/tinyfilemanager-${PV}-personal-changes.patch
)

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	newins tinyfilemanager.php index.php
	doins translation.json

	webapp_serverowned "${MY_HTDOCSDIR}"
	webapp_serverowned "${MY_HTDOCSDIR}"/index.php
	webapp_serverowned "${MY_HTDOCSDIR}"/translation.json

	webapp_src_install
}
