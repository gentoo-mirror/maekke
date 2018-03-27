# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator cmake-utils

DESCRIPTION="Helmut Dersch's panorama toolbox library"
HOMEPAGE="http://panotools.sourceforge.net/"
SRC_URI="mirror://sourceforge/panotools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="java"

DEPEND="media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg:0
	java? ( >=virtual/jdk-1.3 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

src_prepare() {
	sed -i -e "s:share/pano13/doc:share/doc/${PF}:g" \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(usex java SUPPORT_JAVA_PROGRAMS)
	)
	cmake-utils_src_configure
}
