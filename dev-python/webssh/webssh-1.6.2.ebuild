# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1

DESCRIPTION="Web based SSH client"
HOMEPAGE="https://github.com/huashengdun/webssh/"
SRC_URI="https://github.com/huashengdun/webssh/archive/refs/tags/v${PV}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
    acct-user/webssh
    acct-group/webssh
    >=dev-python/paramiko-3.0.0[${PYTHON_USEDEP}]
    >=dev-python/tornado-6.2.0[${PYTHON_USEDEP}]
"

src_install() {
    # Python install
    distutils-r1_src_install

	# Install init+conf files.
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"

    # Create log directory
    keepdir "/var/log/${PN}"
    fowners ${PN}:${PN} "/var/log/${PN}"
}
