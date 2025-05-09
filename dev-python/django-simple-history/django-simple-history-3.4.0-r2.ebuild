# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Stores Django model state on every create/update/delete"
HOMEPAGE="
	https://django-simple-history.readthedocs.io/en/latest/index.html
	https://github.com/jazzband/django-simple-history
"
SRC_URI="$(pypi_sdist_url --no-normalize django-simple-history)"
S=${WORKDIR}/${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/django-5.0[${PYTHON_USEDEP}]
	>=dev-python/asgiref-3.6[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
