# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Maintainer: Frédéric Pierret <frederic.epitre@orange.fr>

EAPI=6

inherit git-r3 eutils multilib

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

KEYWORDS="amd64"
EGIT_REPO_URI="https://github.com/QubesOS/qubes-core-qubesdb.git"
EGIT_COMMIT="v${PV}"
DESCRIPTION="QubesOS libvchan cross-domain communication library"
HOMEPAGE="http://www.qubes-os.org"
LICENSE="GPLv2"

SLOT="0"
IUSE=""

DEPEND="app-emulation/qubes-core-vchan-xen"
RDEPEND=""
PDEPEND=""

src_prepare() {
	einfo "Apply patch set"
    EPATCH_SUFFIX="patch" \
    EPATCH_FORCE="yes" \
    EPATCH_OPTS="-p1" \
    epatch "${FILESDIR}"

	default
}

src_compile() {
    # Build all with python2 bindings
    PYTHON=python2 emake all
}

src_install() {
    # Install all with python2 bindings
    PYTHON=python2 make install DESTDIR=$pkgdir LIBDIR=/usr/lib BINDIR=/usr/bin SBINDIR=/usr/bin
}
