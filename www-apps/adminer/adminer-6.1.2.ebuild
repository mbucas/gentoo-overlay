# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Adminer - Database management in a single PHP file"
HOMEPAGE="https://www.adminer.org/"
SRC_URI="https://github.com/vrana/adminer/releases/download/v${PV}/adminer-${PV}.php"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2 Apache-1.0"

KEYWORDS="~amd64"

IUSE="+mysql postgres sqlite vhosts"

RDEPEND="
	virtual/httpd-php:*
	>=dev-lang/php-8.3
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

	insinto "${MY_HTDOCSDIR}/img"
	newins "${FILESDIR}"/img/edit-db.png edit-db.png
	newins "${FILESDIR}"/img/edit-record.png edit-record.png
	newins "${FILESDIR}"/img/edit-sql.png edit-sql.png
	newins "${FILESDIR}"/img/export.png export.png
	newins "${FILESDIR}"/img/new-db.png new-db.png
	newins "${FILESDIR}"/img/new-record.png new-record.png
	newins "${FILESDIR}"/img/new-sql.png new-sql.png
	newins "${FILESDIR}"/img/new-table.png new-table.png
	newins "${FILESDIR}"/img/show-records.png show-records.png
	newins "${FILESDIR}"/img/show-schema.png show-schema.png
	newins "${FILESDIR}"/img/show-table.png show-table.png

	webapp_src_install
}
