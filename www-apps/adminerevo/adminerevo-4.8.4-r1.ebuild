# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Database management in a single PHP file"
HOMEPAGE="https://docs.adminerevo.org/"
SRC_URI="https://github.com/adminerevo/adminerevo/releases/download/v${PV}/adminer-${PV}.php"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2 Apache-1.0"

KEYWORDS="~amd64"

IUSE="+mysql postgres sqlite vhosts"

RDEPEND="
	virtual/httpd-php:8.2
	dev-lang/php:8.2
	mysql? ( || ( dev-lang/php[mysql] dev-lang/php[mysqli] ) )
	postgres? ( dev-lang/php[postgres] )
	sqlite? ( dev-lang/php[sqlite] )
"

src_unpack() {
	mkdir -p "${S}" || die
	# Source isn't compressed, just minified PHP
	cp "${DISTDIR}/adminer-${PV}.php" "${S}/index.php" || die
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins index.php
	newins "${FILESDIR}"/adminer.css adminer.css

	webapp_src_install
}
