# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="http://git.linaro.org/git-ro/arm/xorg/driver/xf86-video-armsoc.git"

inherit xorg-2

DESCRIPTION="Generic DDX driver for ARM SoCs; based on upstream OMAP driver."
HOMEPAGE="https://git.linaro.org/gitweb?p=arm/xorg/driver/xf86-video-armsoc.git;a=summary"
SRC_URI=""

LICENSE="xf86-video-armsoc-linaro"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND="!x11-drivers/xf86-video-armsoc"
RDEPEND="${DEPEND}"

XORG_CONFIGURE_OPTIONS=( "--with-drmmode=exynos" )
