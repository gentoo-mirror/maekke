# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="multiblend is a multi-level image blender for the seamless blending
of panoramic images"
HOMEPAGE="http://horman.net/multiblend/"
SRC_URI="http://horman.net/multiblend/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/libpng:0=
	media-libs/tiff
	virtual/jpeg"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	local libs="-ltiff -ltiffxx -ljpeg -lpng"
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} ${PN}.cpp ${libs} -o ${PN} || die
}

src_install() {
	dobin ${PN}
	dodoc changelog.txt readme.txt
}
