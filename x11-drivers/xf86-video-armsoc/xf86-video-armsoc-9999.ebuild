# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://chromium.googlesource.com/chromiumos/third_party/${PN}.git"

inherit xorg-2

DESCRIPTION="xf86-video-armsoc driver from google"
HOMEPAGE="http://git.chromium.org/gitweb/?p=chromiumos/third_party/xf86-video-armsoc.git;a=summary"
SRC_URI=""

LICENSE="xf86-video-armsoc"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND="!x11-drivers/xf86-video-armsoc-linaro"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}_compat.patch
)

XORG_CONFIGURE_OPTIONS=(
	"--disable-silent-rules"
	"--disable-selective-werror"
	"--with-driver=exynos"
)
