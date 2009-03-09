# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator cmake-utils

DESCRIPTION="free opensource panoramic viewer"
HOMEPAGE="http://freepv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	dev-libs/libxml2
	media-libs/freeglut
	media-libs/jpeg
	media-libs/libpng
	sys-libs/zlib
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm
	|| ( net-libs/xulrunner www-client/mozilla-firefox )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

