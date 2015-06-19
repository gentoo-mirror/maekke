#!/usr/bin/python

from portage.dbapi.porttree import portdbapi
import subprocess

TREE = "/usr/portage/"

dbapi = portdbapi()
pkgs = dbapi.cp_all(categories=None, trees=[TREE])

for pkg in pkgs:
	res = subprocess.call("egrep -q \"SLOT=\\\"?[0-9]*\/\" %s/%s/*.ebuild" % (TREE, pkg), shell=True)
	if res == 0:
		print("%s" % pkg)

