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

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-copy-paste-from-omap-driver-to-get-it-compiled.patch
)
