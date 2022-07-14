# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_9 python3_10 )

inherit distutils-r1

DESCRIPTION="Twitter Bootstrap for Django Form"
HOMEPAGE="https://github.com/tzangms/django-bootstrap-form"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
