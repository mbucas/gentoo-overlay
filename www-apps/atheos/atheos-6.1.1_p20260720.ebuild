# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Atheos Cloud Based IDE"
HOMEPAGE="https://www.atheos.io/"

GIT_HASH="f90cd1806dbe0e25673a77e27390e8b1a240c3f6"
SRC_URI="https://github.com/Atheos/Atheos/archive/${GIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Atheos-${GIT_HASH}"

LICENSE="MIT"

KEYWORDS="~amd64"

RDEPEND="
	virtual/httpd-php:*
	>=dev-lang/php-8.3
"

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	# Missing config.php
	newins "${FILESDIR}"/config.php config.php

	webapp_serverowned -R "${MY_HTDOCSDIR}"/config.php
	webapp_serverowned -R "${MY_HTDOCSDIR}"/data
	webapp_serverowned -R "${MY_HTDOCSDIR}"/workspace
	webapp_serverowned -R "${MY_HTDOCSDIR}"/plugins
	webapp_serverowned -R "${MY_HTDOCSDIR}"/theme
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_src_install
}
