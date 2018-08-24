# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs cmake-utils

DESCRIPTION="A set of programs for manipulating and viewing HDR images and video frames"
HOMEPAGE="http://pfstools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fftw gsl imagemagick netpbm octave opencv openexr opengl qt5 static-libs tiff"

RDEPEND="
	media-libs/libexif
	fftw? ( sci-libs/fftw )
	gsl? ( sci-libs/gsl )
	imagemagick? ( >=media-gfx/imagemagick-6.0 )
	netpbm? ( media-libs/netpbm )
	octave? ( sci-mathematics/octave )
	opencv? ( media-libs/opencv )
	openexr? ( >=media-libs/openexr-1.0:0= )
	opengl? ( media-libs/freeglut virtual/opengl )
	tiff? ( media-libs/tiff )
	!media-gfx/pfscalibration
	!media-gfx/pfstmo"
DEPEND="${DEPEND}
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"

src_configure() {
	local mycmakeargs=(
		-DWITH_MATLAB=OFF
		-DWITH_ImageMagick=$(usex imagemagick)
		-DWITH_FFTW=$(usex fftw)
		-DWITH_GSL=$(usex gsl)
		-DWITH_NetPBM=$(usex netpbm)
		-DWITH_Octave=$(usex octave)
		-DWITH_OpenCV=$(usex opencv)
		-DWITH_OpenEXR=$(usex openexr)
		-DWITH_pfsglview=$(usex opengl)
		-DWITH_QT=$(usex qt5)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DWITH_TIFF=$(usex tiff)
	)
	cmake-utils_src_configure || die
}
