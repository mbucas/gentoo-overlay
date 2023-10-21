# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools systemd

DESCRIPTION="This is the proxy-daemon used by www-apps/guacamole"

HOMEPAGE="https://guacamole.apache.org/"
SRC_URI="http://mirrors.ircam.fr/pub/apache/guacamole/${PV}/source/guacamole-server-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ffmpeg multilib pulseaudio rdp ssh ssl telnet vnc vorbis webp"
REQUIRED_USE="multilib? ( ssl )"

RDEPEND="
    acct-user/guacd
    acct-group/guacd
	x11-libs/cairo
	virtual/jpeg:0
	media-libs/libpng:0=
    ffmpeg? ( media-video/ffmpeg )
	rdp? ( >=net-misc/freerdp-2.0.0:= )
	ssh? (
		net-libs/libssh2
		x11-libs/pango )
	telnet?	(
		net-libs/libtelnet
		x11-libs/pango )
	vnc? (
		net-libs/libvncserver[threads]
		pulseaudio? ( media-sound/pulseaudio ) )
	ssl? ( dev-libs/openssl:0= )
	vorbis? ( media-libs/libvorbis )
    webp? ( media-libs/libwebp )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/guacamole-${PV}-configure-ac.patch
    "${FILESDIR}"/guacamole-${PV}-ffmpeg-5.patch
)

src_prepare() {
   default
   eautoreconf
}

src_configure() {
	local myconf="--without-terminal --without-pango"

	if use ssh || use telnet; then
		myconf="--with-terminal --with-pango"
	fi

	if use ffmpeg; then
		myconf+=" --with-libavcodec --with-libavformat --with-libavutil --with-libswscale"
	fi

	econf ${myconf} \
		$(use_with pulseaudio pulse) \
		$(use_with rdp) \
		$(use_with ssh) \
		$(use_with telnet) \
		$(use_with vnc) \
		$(use_with ssl) \
		$(use_with vorbis) \
		$(use_with webp)

    # guacenc.c:79:5: error: ‘avcodec_register_all’ is deprecated [-Werror=deprecated-declarations]
    # sed -i s/-Werror// src/guacenc/Makefile
}

src_install() {
	default

	# Install init+conf files.
	newinitd "${FILESDIR}/guacd.init" "guacd"
	newconfd "${FILESDIR}/guacd.conf" "guacd"
	systemd_dounit "${FILESDIR}/guacd.service"
}
