# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit user java-pkg-2

DESCRIPTION="An extendable open source continuous integration server"
HOMEPAGE="http://jenkins-ci.org/"
SRC_URI="http://mirrors.jenkins-ci.org/war/1.474/jenkins.war -> ${P}.war"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=virtual/jdk-1.5"

S="${WORKDIR}"

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup jenkins
	enewuser jenkins -1 -1 /dev/null jenkins
}

src_install() {
	diropts -m755 -o jenkins -g jenkins
	dodir /var/lib/${PN}

	insinto /var/lib/${PN}
	newins "${DISTDIR}"/${P}.war ${PN}.war
	fowners jenkins:jenkins /var/lib/${PN}/${PN}.war

	keepdir /var/log/${PN} /var/run/${PN}
	fowners jenkins:jenkins /var/log/${PN} /var/run/${PN}

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
}
