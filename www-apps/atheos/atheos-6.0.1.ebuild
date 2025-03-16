# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Atheos Cloud Based IDE"
HOMEPAGE="https://www.atheos.io/"
SRC_URI="https://github.com/Atheos/Atheos/archive/refs/tags/v${PV//\./}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
    virtual/httpd-php:8.2
    dev-lang/php:8.2
"

S="${WORKDIR}/Atheos-${PV//\./}"

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
