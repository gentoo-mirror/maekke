#!/bin/bash
# by {maekke,opfer}@gentoo.org

REPODIR="${HOME}/cvs/gentoo-x86"
BUGZ_USER="maekke@gentoo.org"
BUGZ="bugz"

die() {
	echo $@
	exit 1
}

if [[ $# -lt 3 ]] ; then
	echo "usage:"
	echo "   ${0} bug-id \"arch1 arch2...\" pkg1 pkg2 ..."
	echo
	echo "Examples: ${0} 1234 \"amd64 x86\" \$(cat /tmp/kde-3.5.9)"
	echo "          ${0} 2345 ppc =sys-kernel/vanilla-sources-2.6.25"
	echo "          ${0} 456 \"amd64 x86 sparc\" sys-apps/baselayout-2.0.0"
	echo "          ${0} 0 x86 media-gfx/graphviz (will generate a message w/o bug#)"
	exit 1
fi

# some checks, that everything needed is installed
if [[ ! -x $(which q) ]] ; then
	echo "you need portage-utils"
	echo "emerge app-portage/portage-utils"
	exit 1
fi

if [[ ! -d ${REPODIR} ]] ; then
	echo "your \${REPODIR}='${REPODIR}' does not exist."
	exit 1
fi

bugid="${1}"
arches="${2}"
shift 2
pkgs="$@"

# check if arches are sane
for arch in ${arches} ; do
	[[ $(egrep "\<${arch/\~/}\>" ${REPODIR}/profiles/arch.list | wc -l) == 0 ]] && die "invalid arch (${arch})"
done

# commit message
if [ ${arches:0:1} == "~" ] ; then
	msg="add ${arches// //}"
else
	msg="${arches// //} stable"
fi
[[ ${bugid} != "0" ]] && msg="${msg}, bug #${bugid}"

pkgno=0
for pkg in ${pkgs} ; do
	pkgno=$(( ${pkgno} + 1 ))
	echo ">>> processing: ${pkg} (${pkgno}/$#)"
	declare -a qatom
	qatom=($(qatom ${pkg}))
	[[ ${qatom#} < 2 ]] && die "invalid atom ${pkg}"
	category=${qatom[0]/=}
	pn=${qatom[1]}
	version=${qatom[2]}
	revision=${qatom[3]}
	if [ -n "${revision}" ] ; then
		version="${version}-${revision}"
	fi

	cd "${REPODIR}/${category}/${pn}" || die "package ${category}/${pn} not found"
	cvs up || die "cvs up failed"
	repoman -d full || die "repoman full failed"
	ekeyword ${arches} ${pn}-${version}.ebuild || die "ebuild not found"
	repoman -d full || die "repoman full failed"
	echangelog --strict "${msg}" || die "echangelog failed"
	repoman commit -m "${msg}" || die "repoman commit failed"
done

if [[ ${arches:0:1} == "~" ]] ; then
	echo "removing arches from KEYWORDREQ bug unsupported atm"
	exit 0
fi
[[ ${bugid} == 0 ]] && echo "done, as bug# is 0" && exit 0

tmpfile="$(mktemp)"
${BUGZ} --base=https://bugs.gentoo.org get ${bugid} > ${tmpfile}
aliases="$(grep ^CC ${tmpfile} | sed -e "s|CC          : ||g")"
assignee="$(grep ^Assignee ${tmpfile} | sed -e "s|Assignee    : ||")"
rm ${tmpfile}

# only accept arches, no herds/users etc
for alias in ${aliases} ; do
	if [[ $(grep ^${alias/@gentoo.org}\$ ${REPODIR}/profiles/arch.list | wc -l) -gt 0 ]] ; then
		bugarches="${bugarches} ${alias}"
	fi
done

lastarch="1"
for bugarch in ${bugarches} ; do
	found="0"
	for arch in ${arches} ; do
		[[ "${arch}@gentoo.org" == "${bugarch}" ]] && found="1"
	done
	[[ ${found} == 0 ]] && lastarch="0"
done

bugz_options="--base="https://bugs.gentoo.org" --user=${BUGZ_USER}"
for arch in ${arches} ; do
	bugz_options="${bugz_options} --remove-cc=${arch}@gentoo.org"
done

if [[ ${lastarch} == "1" ]] ; then
	bugz_message="${arches// //} stable, all arches done."
	[[ ${assignee} != "security@gentoo.org" ]] && bugz_options="${bugz_options} --fixed"
else
	bugz_message="${arches// //} stable"
fi

echo "running ${BUGZ} modify ${bugid} ${bugz_options} --comment=\"${bugz_message}\""
${BUGZ} modify ${bugid}  ${bugz_options} --comment="${bugz_message}" || die "bugz failed"
echo ">>> finished successfully"
