# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=BPOSTLE
inherit perl-module

DESCRIPTION="A perl module for reading, writing and manipulating hugin script files"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	dev-perl/ImageSize
	media-gfx/enblend
	media-gfx/hugin
	media-gfx/imagemagick"
DEPEND="${RDEPEND}"

# src_test doesn't like parallel-make
MAKEOPTS="${MAKEOPTS} -j1"
SRC_TEST="do"
