#!/bin/bash
# find packages with subslots

PORTDIR="${HOME}/cvs/gentoo-x86"

pushd "${PORTDIR}" > /dev/null

for pkg in $(find . -mindepth 2 -maxdepth 2 -type d | sort) ; do
	pushd ${pkg} > /dev/null
	if [[ -n $(find . -name '*.ebuild') ]] ; then
		[[ -n $(egrep "SLOT=\"?[0-9]*\/" *.ebuild) ]] && echo ${pkg/\.\//}
	fi
	popd > /dev/null # ${pkg}
done

popd > /dev/null # ${PORTDIR}
