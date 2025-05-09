# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Twitter Bootstrap for Django Form"
HOMEPAGE="https://github.com/tzangms/django-bootstrap-form"
SRC_URI="$(pypi_sdist_url --no-normalize django-bootstrap-form)"
S=${WORKDIR}/${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-python/django-5.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
