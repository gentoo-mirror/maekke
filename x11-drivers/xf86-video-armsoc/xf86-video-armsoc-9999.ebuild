# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://chromium.googlesource.com/chromiumos/third_party/${PN}.git"

inherit xorg-3

DESCRIPTION="xf86-video-armsoc driver from google"
HOMEPAGE="http://git.chromium.org/gitweb/?p=chromiumos/third_party/xf86-video-armsoc.git;a=summary"
SRC_URI=""

LICENSE="xf86-video-armsoc"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND=">=x11-libs/libdrm-2.4.30[video_cards_exynos]
	!x11-drivers/xf86-video-armsoc-linaro"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}_compat.patch
	"${FILESDIR}"/${PN}_xorg-server-includes.patch
)

XORG_CONFIGURE_OPTIONS=(
	"--disable-silent-rules"
	"--disable-selective-werror"
	"--with-driver=exynos"
)
