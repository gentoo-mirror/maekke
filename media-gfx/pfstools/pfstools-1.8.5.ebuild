# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base multilib autotools toolchain-funcs

DESCRIPTION="${PN} package is a set of command line programs for reading,
writing and manipulating HDR images"
HOMEPAGE="http://pfstools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gdal imagemagick netpbm octave openexr opengl qt4 static-libs tiff"

RDEPEND="
	gdal? ( sci-libs/gdal )
	imagemagick? ( >=media-gfx/imagemagick-6.0 )
	netpbm? ( media-libs/netpbm )
	octave? ( sci-mathematics/octave )
	openexr? ( >=media-libs/openexr-1.0:0= )
	opengl? ( media-libs/freeglut )
	tiff? ( media-libs/tiff )"
DEPEND="${DEPEND}
	qt4? ( dev-qt/qtgui:4 )"

PATCHES=( "${FILESDIR}"/${PN}-1.8.1-glibc-2.10.patch
		  "${FILESDIR}"/${PN}-1.8.4-fixmoc.patch )

src_prepare() {
	base_src_prepare || die
	eautoreconf
}

src_configure() {
	# TODO set current octave version --with-octversion

	unset QTDIR
	export QT_CFLAGS="$($(tc-getPKG_CONFIG) QtGui --cflags)"
	export QT_LIBS="$($(tc-getPKG_CONFIG) QtGui --libs)"

	econf \
		--disable-jpeghdr \
		--disable-matlab \
		$(use_enable debug) \
		$(use_enable gdal) \
		$(use_enable imagemagick) \
		$(use_enable netpbm) \
		$(use_enable octave) \
		$(use_enable openexr) \
		$(use_enable opengl) \
		$(use_enable static-libs static) \
		$(use_enable tiff) \
		$(use_enable qt4 qt)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README

	if ! use static-libs; then
		rm "${D}"/usr/$(get_libdir)/*.la || die
	fi
}
