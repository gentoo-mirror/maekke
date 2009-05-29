# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/data-buffer/data-buffer-0.04.ebuild,v 1.19 2007/07/10 23:33:33 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="A perl module for reading, writing and manipulating hugin script files"
HOMEPAGE="http://search.cpan.org/~bpostle/Panotools-Script-0.22/"
SRC_URI="mirror://cpan/authors/id/B/BP/BPOSTLE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

# TODO check deps for:
#Some of the scripts require 'nona', 'freepv', 'enblend', 'autotrace' and
#ImageMagick command-line tools.

RDEPEND="
	dev-perl/ImageSize
	media-gfx/hugin
	media-gfx/imagemagick"
DEPEND="${RDEPEND}"
