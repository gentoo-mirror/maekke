# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/rawstudio/rawstudio-1.2.ebuild,v 1.7 2011/03/12 10:34:50 radhermit Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="a program to read and manipulate raw images from digital cameras."
HOMEPAGE="http://rawstudio.org"
SRC_URI="http://${PN}.org/files/release/${P}.tar.gz"

LICENSE="GPL-2 CCPL-Attribution-NoDerivs-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite
	>=dev-libs/libxml2-2.4
	>=gnome-base/gconf-2
	media-gfx/exiv2
	=media-libs/lcms-1*
	media-libs/lensfun
	media-libs/libgphoto2
	media-libs/tiff
	net-misc/curl
	sci-libs/fftw:3.0
	sys-apps/dbus
	virtual/jpeg
	>=x11-libs/gtk+-2.8:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch
	epatch "${FILESDIR}"/${P}-flickr.patch
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
