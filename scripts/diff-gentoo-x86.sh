#!/bin/sh

CVS_DIR="${HOME}/cvs/gentoo-x86"
OVERLAY="${HOME}/cvs/maekke"

pushd "${OVERLAY}" > /dev/null

for pkg in *-*/* ; do
	if [[ -d ${CVS_DIR}/${pkg} ]] ; then
		echo ">>> ${pkg}"
		diff -ru -x CVS -x ChangeLog -x Manifest -I "^# \$Header:" "${CVS_DIR}"/${pkg} ${pkg}
	fi
done

popd > /dev/null
