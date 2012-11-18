# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/enblend/enblend-4.0.ebuild,v 1.12 2012/05/05 07:00:26 jdhore Exp $

EAPI=2

inherit eutils

MY_P="${PN}-enfuse-${PV/_rc/rc}-e436ceb4899a"

DESCRIPTION="Image Blending with Multiresolution Splines"
HOMEPAGE="http://enblend.sourceforge.net/"
SRC_URI="mirror://sourceforge/enblend/${MY_P}.tar.gz"

LICENSE="GPL-2 VIGRA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc gpu +image-cache +openexr openmp"

RDEPEND="
	media-libs/glew
	=media-libs/lcms-2*
	>=media-libs/libpng-1.2.43
	media-libs/plotutils[X]
	media-libs/tiff
	>=media-libs/vigra-1.8.0
	virtual/jpeg
	gpu? ( media-libs/freeglut )
	openexr? ( >=media-libs/openexr-1.0 )"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.31.0
	virtual/pkgconfig
	doc? (
		media-gfx/transfig
		sci-visualization/gnuplot[gd]
		virtual/latex-base
	)"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use image-cache && use openmp; then
		ewarn "the openmp and image-cache USE-flags are mutually exclusive"
		ewarn "image-cache will be disabled in favour of openmp"
	fi
}

src_configure() {
	local myconf=""
	if use image-cache && use openmp; then
		myconf="--disable-image-cache --enable-openmp"
	else
		myconf="$(use_enable image-cache) $(use_enable openmp)"
	fi

	use doc && myconf="${myconf} --with-gnuplot=$(type -p gnuplot)" \
		|| myconf="${myconf} --with-gnuplot=false"

	econf \
		--with-x \
		$(use_enable debug) \
		$(use_enable gpu gpu-support) \
		$(use_with openexr) \
		${myconf}
}

src_compile() {
	# forcing -j1 as every parallel compilation process needs about 1 GB RAM.
	emake -j1 || die
	if use doc; then
		cd doc
		make enblend.pdf enfuse.pdf || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die
	use doc && dodoc doc/en{blend,fuse}.pdf
}
