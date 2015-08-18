#!/bin/sh

GENTOO="${HOME}/cvs/gentoo"
OVERLAY="${HOME}/cvs/maekke"

pushd "${OVERLAY}" > /dev/null

for pkg in *-*/* ; do
	if [[ -d ${GENTOO}/${pkg} ]] ; then
		echo ">>> ${pkg}"
		diff -ru -x Manifest "${GENTOO}"/${pkg} ${pkg}
	fi
done

popd > /dev/null
