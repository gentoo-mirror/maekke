# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit java-pkg-opt-2 cmake

DESCRIPTION="Helmut Dersch's panorama toolbox library"
HOMEPAGE="http://panotools.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/panotools/${P}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="java static-libs suitesparse"

DEPEND="media-libs/libpng:=
	media-libs/tiff:=
	media-libs/libjpeg-turbo:=
	sys-libs/zlib
	java? ( >=virtual/jdk-1.8:* )
	suitesparse? ( sci-libs/suitesparse )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gcc15.patch"
	"${FILESDIR}/${P}-fabs-sqrt.patch"
)

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DSUPPORT_JAVA_PROGRAMS=$(usex java)
		-DUSE_SPARSE_LEVMAR=$(usex suitesparse)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use static-libs ; then
		find "${D}" -name "*.a" -type f -delete || die
	fi
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}
