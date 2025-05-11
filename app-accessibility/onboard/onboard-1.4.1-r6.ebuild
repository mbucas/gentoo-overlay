# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12,13} )

inherit distutils-r1 gnome2-utils

DESCRIPTION="Onscreen keyboard for everybody who can't use a hardware keyboard"
HOMEPAGE="https://launchpad.net/onboard"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

# po/* are licensed under BSD 3-clause
LICENSE="GPL-3+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="app-text/hunspell:=
	dev-libs/dbus-glib
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/dconf
	gnome-base/gsettings-desktop-schemas
	gnome-base/librsvg
	media-libs/libcanberra
	sys-apps/dbus
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[introspection]
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libwnck:3
	x11-libs/pango"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool"
RDEPEND="${COMMON_DEPEND}
	app-accessibility/at-spi2-core
	app-text/iso-codes
	gnome-extra/mousetweaks
	x11-libs/libxkbfile"

RESTRICT="mirror"

# These are using a functionality of distutils-r1.eclass
DOCS=( AUTHORS CHANGELOG HACKING NEWS README onboard-defaults.conf.example
	onboard-default-settings.gschema.override.example )

# Debian patches from Ubuntu onboard 1.4.1-10 source package under same license GPL-3+
# See https://launchpad.net/ubuntu/+source/onboard/1.4.1-10
PATCHES=(
	"${FILESDIR}/debian-0001-Replace-invalid-UTF-8-characters-in-ACPI-events.patch"
	"${FILESDIR}/debian-1001_desktop-file-fixes.patch"
	"${FILESDIR}/debian-1002_build-against-Ayatana-AppIndicator.patch"
	"${FILESDIR}/debian-1003_disable_onboard_on_gnome.patch"
	"${FILESDIR}/debian-1004-fix-ftbfs-python3-12.patch"
	"${FILESDIR}/debian-1005_fix-invalid-escape-sequences.patch"
	"${FILESDIR}/debian-1006_fix-str-not-callable-in-LayoutLoaderSVG-py.patch"
	"${FILESDIR}/debian-1007-fix-test-dependencies.patch"
	"${FILESDIR}/debian-1008_enable-tests-during-build.patch"
	"${FILESDIR}/debian-1010_arctica-greeter.patch"
	"${FILESDIR}/debian-1011_python-distutils-byebye.patch"
	"${FILESDIR}/debian-1012_thread-state.patch"
	"${FILESDIR}/debian-1013_slow-down-tests-for-riscv64.patch"
	"${FILESDIR}/debian-2001_drop-gui-test.patch"
	"${FILESDIR}/debian-2002_drop-dbus-test.patch"
	"${FILESDIR}/${P}-include-stdbool.patch"
	"${FILESDIR}/${P}-remove-duplicated-docs.patch"
)

src_prepare() {
	distutils-r1_src_prepare
	eapply_user
}

src_install() {
	distutils-r1_src_install

	# Delete duplicated docs installed by original dustutils
	rm "${D}"/usr/share/doc/onboard/*
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
