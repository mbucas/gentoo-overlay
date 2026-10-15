# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Single-file PHP file manager"
HOMEPAGE="https://tinyfilemanager.github.io/"

GIT_HASH="41491439a6b243c55502581e53fad20bc4c6e777"
SRC_URI="https://github.com/prasathmani/tinyfilemanager/archive/${GIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_HASH}"

LICENSE="GPL-3"

KEYWORDS="~amd64"

RDEPEND="
	virtual/httpd-php:*
	>=dev-lang/php-8.3
	dev-lang/php[fileinfo,iconv,zip]
"

PATCHES=(
	"${FILESDIR}"/tinyfilemanager-2.6-personal-changes.patch
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
