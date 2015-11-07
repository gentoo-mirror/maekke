# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs cmake-utils

DESCRIPTION="${PN} package is a set of command line programs for reading,
writing and manipulating HDR images"
HOMEPAGE="http://pfstools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fftw gsl imagemagick netpbm octave opencv openexr opengl qt4 static-libs tiff"

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
	qt4? ( dev-qt/qtgui:4 )"

src_configure() {
	local mycmakeargs=(
		-DWITH_MATLAB=OFF
		-DWITH_ImageMagick=$(usex imagemagick ON OFF)
		-DWITH_FFTW=$(usex fftw ON OFF)
		-DWITH_GSL=$(usex gsl ON OFF)
		-DWITH_NetPBM=$(usex netpbm ON OFF)
		-DWITH_Octave=$(usex octave ON OFF)
		-DWITH_OpenCV=$(usex opencv ON OFF)
		-DWITH_OpenEXR=$(usex openexr ON OFF)
		-DWITH_pfsglview=$(usex opengl ON OFF)
		-DWITH_QT=$(usex qt4 ON OFF)
		-DBUILD_SHARED_LIBS=$(usex !static-libs ON OFF)
		-DWITH_TIFF=$(usex tiff ON OFF)
	)
	cmake-utils_src_configure || die
}
