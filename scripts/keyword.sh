#!/bin/bash
# by {maekke,opfer}@gentoo.org

REPODIR="${HOME}/git/gentoo"
BUGZ_USER="maekke@gentoo.org"
BUGZ="bugz"
BUGZ_DEFAULT_OPTS="--base https://bugs.gentoo.org/xmlrpc.cgi --user ${BUGZ_USER}"

FEATURES="${FEATURES} sign"

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
	echo "          ${0} -m \"some bug message\+ 1234 \"amd64 arm\+ sys-apps/baselayout-2.0.0"
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

if [[ ${1} == "-m" ]]; then
	shift
	bugz_message="$1"
	shift
fi

bugid="${1}"
arches="${2}"
shift 2
pkgs="$@"

# check if arches are sane
for arch in ${arches} ; do
	[[ $(egrep "\<${arch/\~/}\>" ${REPODIR}/profiles/arch.list | wc -l) == 0 ]] && die "invalid arch (${arch})"
done

pkgno=0
for pkg in ${pkgs} ; do
	pkgno=$(( ${pkgno} + 1 ))
	echo ">>> processing: ${pkg} (${pkgno}/$#)"
	declare -a qatom
	qatom=($(qatom ${pkg/=/}))
	[[ ${qatom#} < 2 ]] && die "invalid atom ${pkg}"
	category=${qatom[0]/=}
	pn=${qatom[1]}
	cpn=${category}/${pn}
	version=${qatom[2]}
	revision=${qatom[3]}
	[[ -n "${revision}" ]] && version="${version}-${revision}"

	cd "${REPODIR}/${cpn}" || die "package ${cpn} not found"
	[[ -e ${pn}-${version}.ebuild ]] || die "ebuild (${pn}-${version}) not found"
	git checkout HEAD . || die "git checkout HEAD failed"
	repoman full --include-arches "${arches//\~/}" || die "repoman full failed on non-modified tree"

	# detect which arches to commit (the ones w/o stable)
	tmparches=""
	for arch in ${arches} ; do
		if [[ -z $(egrep "KEYWORDS=.*(\"| )\<${arch}\>" ${pn}-${version}.ebuild) ]] ; then
			[[ -z ${tmparches} ]] && tmparches="${arch}" || tmparches="${tmparches} ${arch}"
		fi
	done

	# commit message
	if [[ ${arches:0:1} == "~" ]] ; then
		msg="${cpn}: add ${arches// //}"
	else
		msg="${cpn}: ${tmparches// //} stable"
	fi
	[[ ${bugid} != "0" ]] && msg="${msg}, bug #${bugid}"

	if [[ -n ${tmparches} ]] ; then
		ekeyword ${tmparches} ${pn}-${version}.ebuild || die "ebuild not found"
		repoman manifest || die "repoman manifest failed"
		repoman full --include-arches "${arches//\~/}" || die "repoman full failed on modified tree"
		repoman commit --include-arches "${arches//\~/}" -m "${msg}" || die "repoman commit failed"
	else
		echo "nothing to do here"
	fi
done

git pull --rebase=preserve -S"$(git config --get user.signingkey)" || die "git pull failed"
#git push --signed || die "git push failed"

if [[ ${arches:0:1} == "~" ]] ; then
	echo "removing arches from KEYWORDREQ bug unsupported atm"
	exit 0
fi
[[ ${bugid} == 0 ]] && echo "done, as bug# is 0" && exit 0

tmpfile="$(mktemp)"
${BUGZ} ${BUGZ_DEFAULT_OPTS} get ${bugid} > ${tmpfile}
aliases="$(grep ^CC ${tmpfile} | awk '{ print $3 }')"
assignee="$(grep ^AssignedTo ${tmpfile} | awk '{ print $3 }')"
rm ${tmpfile}

[[ -z ${assignee} ]] && die "problem with bugz: assignee empty"
[[ -z ${aliases} ]] && die "problem with bugz: aliases empty"

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

bugz_options=""
for arch in ${arches} ; do
	bugz_options="${bugz_options} --remove-cc ${arch}@gentoo.org"
done

if [[ ${lastarch} == "1" ]] ; then
	[[ -z ${bugz_message} ]] && bugz_message="${arches// //} stable, all arches done."
	[[ ${assignee} != "security@gentoo.org" ]] && bugz_options="${bugz_options} --fixed"
else
	[[ -z ${bugz_message} ]] && bugz_message="${arches// //} stable"
fi

echo "running ${BUGZ} ${BUGZ_DEFAULT_OPTS} modify ${bugid} ${bugz_options} --comment \"${bugz_message}\""
${BUGZ} ${BUGZ_DEFAULT_OPTS} modify ${bugid} ${bugz_options} --comment "${bugz_message}" || die "bugz failed"
echo ">>> finished successfully"
