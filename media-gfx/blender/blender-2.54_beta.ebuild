# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/blender/blender-2.49b.ebuild,v 1.4 2010/11/08 22:00:56 maekke Exp $

EAPI=2
PYTHON_DEPEND="3:3.1"
inherit multilib eutils python cmake-utils

MY_P="${P/_beta/-beta}"

IUSE="blender-game ffmpeg fftw lcms nls openexr jpeg2k openmp openal sndfile tiff"

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="http://www.blender.org/"
SRC_URI="http://download.blender.org/source/${MY_P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 BL BSD )"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="media-libs/libpng
	media-libs/libsamplerate
	>=media-libs/libsdl-1.2
	virtual/jpeg
	virtual/opengl
	blender-game? ( >=media-libs/libsdl-1.2[joystick] )
	ffmpeg? ( >=media-video/ffmpeg-0.5[encode,theora] )
	fftw? ( sci-libs/fftw )
	jpeg2k? ( media-libs/openjpeg )
	lcms? ( media-libs/lcms )
	nls? ( >=media-libs/freetype-2.0
		virtual/libintl
		>=media-libs/ftgl-2.1 )
	openal? ( >=media-libs/openal-1.6.372
		>=media-libs/freealut-1.1.0-r1 )
	openexr? ( media-libs/openexr )
	sndfile? ( media-libs/libsndfile )
	tiff? ( media-libs/tiff )"
DEPEND="${RDEPEND}
	sys-devel/gcc[openmp?]
	x11-base/xorg-server"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	mycmakeargs=(
		$(cmake-utils_use_with blender-game GAMEENGINE)
		$(cmake-utils_use_with blender-game PLAYER)
		$(cmake-utils_use_with ffmpeg)
		$(cmake-utils_use_with fftw FFTW3)
		$(cmake-utils_use_with jpeg2k OPENJPEG)
		$(cmake-utils_use_with lcms)
		$(cmake-utils_use_with nls INTERNATIONAL)
		$(cmake-utils_use_with openal)
		$(cmake-utils_use_with openexr)
		$(cmake-utils_use_with openmp)
		$(cmake-utils_use_with sndfile)
		$(cmake-utils_use_with tiff)
	)
}

pkg_preinst(){
	if [ -h "${ROOT}/usr/$(get_libdir)/blender/plugins/include" ];
	then
		rm -f "${ROOT}"/usr/$(get_libdir)/blender/plugins/include
	fi
}

pkg_postinst(){
	elog "blender uses python integration.  As such, may have some"
	elog "inherit risks with running unknown python scripting."
	elog " "
	elog "CVE-2008-1103-1.patch has been removed as it interferes"
	elog "with autosave undo features. Up stream blender coders"
	elog "have not addressed the CVE issue as the status is still"
	elog "a CANDIDATE and not CONFIRMED."
	elog " "
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to ~tmp or another tmp file under your home"
	elog "directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
}
