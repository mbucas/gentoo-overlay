# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd old-user

DESCRIPTION="This is the proxy-daemon used by www-apps/guacamole"

HOMEPAGE="https://guacamole.apache.org/"
SRC_URI="http://mirrors.ircam.fr/pub/apache/guacamole/${PV}/source/guacamole-server-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="multilib pulseaudio rdp ssh ssl telnet vnc vorbis"
REQUIRED_USE="multilib? ( ssl )"

RDEPEND="
	x11-libs/cairo
	media-libs/libpng:0=
	virtual/jpeg:0
	dev-libs/ossp-uuid
	rdp? ( >=net-misc/freerdp-1.1.0_beta1_p20150312:= )
	ssh? (
		x11-libs/pango
		net-libs/libssh2 )
	telnet?	(
		net-libs/libtelnet
		x11-libs/pango )
	vnc? (
		net-libs/libvncserver[threads]
		pulseaudio? ( media-sound/pulseaudio ) )
	ssl? ( dev-libs/openssl:0= )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}"

src_configure() {
	local myconf="--without-terminal --without-pango"

	if use ssh || use telnet; then
		myconf="--with-terminal --with-pango"
	fi

	econf ${myconf} \
		$(use_with ssh) \
		$(use_with rdp) \
		$(use_with vnc) \
		$(use_with pulseaudio pulse) \
		$(use_with vorbis) \
		$(use_with telnet) \
		$(use_with ssl)

    # guacenc.c:79:5: error: ‘avcodec_register_all’ is deprecated [-Werror=deprecated-declarations]
    sed -i s/-Werror// src/guacenc/Makefile
}

src_install() {
	default
	doinitd "${FILESDIR}/guacd"
	systemd_dounit "${FILESDIR}/guacd.service"
}

pkg_postinst() {
	enewgroup guacd
	enewuser guacd -1 -1 -1 guacd
}
