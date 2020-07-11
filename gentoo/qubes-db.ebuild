# Maintainer: Frédéric Pierret <frederic.pierret@qubes-os.org>

EAPI=6

inherit git-r3 eutils multilib

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

KEYWORDS="~amd64"
EGIT_REPO_URI="https://github.com/QubesOS/qubes-core-qubesdb.git"
EGIT_COMMIT="v${PV}"
DESCRIPTION="QubesDB libs and daemon service"
HOMEPAGE="http://www.qubes-os.org"
LICENSE="GPLv2"

SLOT="0"
IUSE=""

DEPEND="app-emulation/qubes-libvchan-xen"
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
    myopt="${myopt} DESTDIR=${D} SYSTEMD=1 BACKEND_VMM=xen"
    emake ${myopt} all
}

src_install() {
    emake ${myopt} install

    dodir /usr/lib/systemd/system/
    insopts -m 0644
    insinto /usr/lib/systemd/system/
    doins daemon/qubes-db.service
}

pkg_postinst() {
    systemctl enable qubes-db.service
}

pkg_postrm() {
    systemctl disable qubes-db.service
}