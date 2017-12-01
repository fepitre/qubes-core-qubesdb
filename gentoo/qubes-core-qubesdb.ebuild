# Maintainer: Frédéric Pierret <frederic.epitre@orange.fr>

EAPI=6

inherit git-r3 eutils multilib

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

KEYWORDS="amd64"
EGIT_REPO_URI="https://github.com/QubesOS/qubes-core-qubesdb.git"
EGIT_COMMIT="v${PV}"
DESCRIPTION="QubesDB libs and daemon service"
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
    myopt="${myopt} DESTDIR="${D}" SYSTEMD=0 BACKEND_VMM=xen"

    # Build all with python2 bindings
    emake PYTHON=python2 ${myopt} all

    # Build python3 bindings
    emake ${myopt} -C python
}

src_install() {
    # Install all with python2 bindings
    emake PYTHON=python2 ${myopt} install

    # Install python3 bindings
    emake ${myopt} -C python install

    newinitd "${FILESDIR}"/qubesdb-daemon.initd qubesdb-daemon
    newconfd "${FILESDIR}"/qubesdb-daemon.confd qubesdb-daemon
}
