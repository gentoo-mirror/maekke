# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="a free astronomical image processing software"
HOMEPAGE="https://free-astro.org/index.php/Siril"
SRC_URI="https://free-astro.org/download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/libconfig[cxx]
	media-libs/giflib
	media-libs/libpng:0=
	media-libs/libraw:=
	media-libs/tiff:0=
	sci-libs/cfitsio
	sci-libs/fftw:3.0=
	sci-libs/gsl
	virtual/jpeg:0
	>=x11-libs/gtk+-3.6.0:3"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
