# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="https://git.chromium.org/git/chromiumos/third_party/xf86-video-armsoc.git"

inherit xorg-2

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND="!x11-drivers/xf86-video-armsoc-linaro"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}_compat.patch
)

XORG_CONFIGURE_OPTIONS=( "--disable-silent-rules" "--disable-selective-werror" )
