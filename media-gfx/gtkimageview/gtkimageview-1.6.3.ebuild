# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="GtkImageView is a simple image viewer widget for GTK."
HOMEPAGE="http://trac.bjourne.webfactional.com/wiki"
SRC_URI="http://trac.bjourne.webfactional.com/attachment/wiki/WikiStart/${P}.tar.gz?format=raw
-> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="gnome-base/gnome-common
	>=x11-libs/gtk+-2.6"
RDEPEND="${DEPEND}"

src_test() {
	# the tests are only built, but not run by default
	local failed=""
	emake check || die
	cd "${S}"/tests
	for i in test-* ; do
		if [ -x ${i} ] ; then
			./${i} || failed="1"
		fi
	done
	[ -n ${failed} ] && die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README || die
}

