# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils libtool multilib

MY_P="${P/_beta/beta}"

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="cxx jbig jpeg mdi static-libs zlib"

DEPEND="jpeg? ( >=media-libs/jpeg-6b )
	jbig? ( >=media-libs/jbigkit-1.6-r1 )
	zlib? ( >=sys-libs/zlib-1.1.3-r2 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_beta/beta}"

src_configure() {
	use prefix || EPREFIX=
	econf \
		--disable-dependency-tracking \
		$(use_enable cxx) \
		$(use_enable jbig) \
		$(use_enable jpeg) \
		$(use_enable mdi) \
		$(use_enable static-libs static) \
		$(use_enable zlib) \
		--without-x \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README TODO VERSION
	if ! use static-libs; then
		find "${D}"/usr/$(get_libdir) -name '*.la' -delete || die
	fi
}

pkg_postinst() {
	if use jbig; then
		echo
		elog "JBIG support is intended for Hylafax fax compression, so we"
		elog "really need more feedback in other areas (most testing has"
		elog "been done with fax).  Be sure to recompile anything linked"
		elog "against tiff if you rebuild it with jbig support."
		echo
	fi
}
