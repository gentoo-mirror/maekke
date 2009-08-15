# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON="2.5"

inherit distutils versionator

MY_PV="$(get_version_component_range 1-3)pre_rev$(get_version_component_range 4)"

DESCRIPTION="An open source vector graphics editor similar to CorelDRAW(tm)."
HOMEPAGE="http://sk1project.org"
SRC_URI="http://sk1project.org/downloads/sk1/${MY_PV}/${PN/K/k}-${MY_PV}.tar.gz"
LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/python[tk]
	>=dev-lang/tcl-8.5
	>=dev-lang/tk-8.5
	media-libs/lcms[python]
	dev-python/imaging[tk]"
DEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)pre"
