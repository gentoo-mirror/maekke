# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-3.8.2-r4.ebuild,v 1.3 2008/08/30 11:31:16 dertobi123 Exp $

inherit eutils libtool

MY_P="${P/_beta/beta}"

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="cxx jpeg jbig mdi zlib"

DEPEND="jpeg? ( >=media-libs/jpeg-6b )
	jbig? ( >=media-libs/jbigkit-1.6-r1 )
	zlib? ( >=sys-libs/zlib-1.1.3-r2 )"

S="${WORKDIR}/${P/_beta/beta}"

src_compile() {
	econf \
		$(use_enable cxx cxx) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		$(use_enable mdi) \
		$(use_enable zlib) \
		--with-docdir=/usr/share/doc/${PF} \
		--with-pic \
		--without-x
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc README TODO VERSION
}

pkg_postinst() {
	# TODO still needed?
	echo
	elog "JBIG support is intended for Hylafax fax compression, so we"
	elog "really need more feedback in other areas (most testing has"
	elog "been done with fax).  Be sure to recompile anything linked"
	elog "against tiff if you rebuild it with jbig support."
	echo
}
