# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="fast and easy graphics application for digital painters"
HOMEPAGE="http://mypaint.intilinux.com/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygtk
	dev-python/numpy
	>=dev-python/pycairo-1.4
	=dev-lang/python-2*
	dev-libs/protobuf[python]"
DEPEND="${RDEPEND}
	>=dev-util/scons-1.0
	dev-lang/swig"

src_compile() {
	scons || die "scons failed"
}

src_install () {
	scons prefix="${D}/usr" install || die
	#doicon desktop/mypaint_48.png
	newicon pixmaps/mypaint_logo.png mypaint.png || die
	dodoc changelog || die
}
