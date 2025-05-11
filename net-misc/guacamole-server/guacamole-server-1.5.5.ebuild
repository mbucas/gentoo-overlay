# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools systemd

DESCRIPTION="This is the proxy-daemon used by www-apps/guacamole"

HOMEPAGE="https://guacamole.apache.org/"
SRC_URI="http://mirrors.ircam.fr/pub/apache/guacamole/${PV}/source/guacamole-server-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="ffmpeg multilib pulseaudio rdp ssl vnc vorbis webp"
REQUIRED_USE="multilib? ( ssl )"

RDEPEND="
	acct-user/guacd
	acct-group/guacd
	x11-libs/cairo
	virtual/jpeg:0
	media-libs/libpng:0=
	net-libs/libssh2
	x11-libs/pango
	ffmpeg? ( media-video/ffmpeg )
	rdp? ( >=net-misc/freerdp-2.0.0:= )
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
	"${FILESDIR}"/guacamole-${PV}-ffmpeg-7.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf="--with-terminal --with-pango"

	if use ffmpeg; then
		myconf+=" --with-libavcodec --with-libavformat --with-libavutil --with-libswscale"
	fi

	econf ${myconf} \
		$(use_with pulseaudio pulse) \
		$(use_with rdp) \
		$(use_with vnc) \
		$(use_with ssl) \
		$(use_with vorbis) \
		$(use_with webp)
}

src_install() {
	default

	# Install init+conf files.
	newinitd "${FILESDIR}/guacd.init" "guacd"
	newconfd "${FILESDIR}/guacd.conf" "guacd"
	systemd_dounit "${FILESDIR}/guacd.service"
}
