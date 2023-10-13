# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_10 python3_11 )

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
IUSE=""

DEPEND="
    >=dev-python/django-4.2[${PYTHON_USEDEP}]
    >=dev-python/asgiref-3.6[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
