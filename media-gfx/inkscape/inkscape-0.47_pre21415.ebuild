# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2 eutils autotools

if [[ "${PV}" == *_pre* ]] ; then
	inherit versionator
	REV="$(get_version_component_range 3)"
	SRC_URI="http://inkscape.modevia.com/svn-snap/${PN}-${REV/pre}.tar.bz2"
	S="${WORKDIR}/${PN}-${REV/pre}"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi

DESCRIPTION="A SVG based generic vector-drawing program"
HOMEPAGE="http://www.inkscape.org/"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="dia doc gnome inkjar jabber lcms mmx perl postscript spell wmf wpg"
RESTRICT="test"

COMMON_DEPEND="
	>=virtual/poppler-glib-0.8.3[cairo]
	dev-cpp/glibmm
	>=dev-cpp/gtkmm-2.10.0
	>=dev-libs/boehm-gc-6.4
	dev-libs/boost
	>=dev-libs/glib-2.6.5
	>=dev-libs/libsigc++-2.0.12
	>=dev-libs/libxml2-2.6.20
	>=dev-libs/libxslt-1.0.15
	dev-libs/popt
	dev-python/lxml
	dev-python/pyxml
	media-gfx/imagemagick
	media-libs/fontconfig
	>=media-libs/freetype-2
	media-libs/libpng
	x11-libs/libXft
	>=x11-libs/gtk+-2.10.7
	>=x11-libs/pango-1.4.0
	gnome? ( >=gnome-base/gnome-vfs-2.0 )
	lcms? ( >=media-libs/lcms-1.14 )
	perl? (
		dev-perl/XML-Parser
		dev-perl/XML-XQL
	)
	spell? ( app-text/gtkspell )
	wpg? ( >=media-libs/libwpg-0.1 )"

# These only use executables provided by these packages
# See share/extensions for more details. inkscape can tell you to
# install these so we could of course just not depend on those and rely
# on that.
RDEPEND="
	${COMMON_DEPEND}
	dev-python/numpy
	dia? ( app-office/dia )
	postscript? ( >=media-gfx/pstoedit-3.44[plotutils] media-gfx/skencil )
	wmf? ( media-libs/libwmf )"

DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	x11-libs/libX11
	>=dev-util/intltool-0.29"

pkg_setup() {
	G2CONF="${G2CONF} --with-xft"
	G2CONF="${G2CONF} $(use_with spell gtkspell)"
	G2CONF="${G2CONF} $(use_enable jabber inkboard)"
	G2CONF="${G2CONF} $(use_enable mmx)"
	G2CONF="${G2CONF} $(use_with inkjar)"
	G2CONF="${G2CONF} $(use_with gnome gnome-vfs)"
	G2CONF="${G2CONF} $(use_enable lcms)"
	G2CONF="${G2CONF} $(use_with perl)"
}

src_prepare() {
	gnome2_src_prepare
	sh autogen.sh || die
	eautoreconf
}

DOCS="AUTHORS ChangeLog NEWS README"
