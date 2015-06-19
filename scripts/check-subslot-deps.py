#!/usr/bin/python

from portage.dbapi.porttree import portdbapi
from portage.versions import catpkgsplit
import io
import re

class CheckSubSlot:
	def __init__(self):
		self.dbapi = portdbapi()
		self.subslottedCp = []
		with open("subslotted-packages.txt", "r") as f:
			for line in f:
				self.subslottedCp.append(line[:-1])

	def checkPackage(self, cpv):
		deps = self._getDepend(cpv)
		missingSubSlotDep = []
		for dep in deps:
			cp = self._getCP(dep)
			if cp in self.subslottedCp and not self._isSubSlotDep(dep):
				missingSubSlotDep.append(cp)
		if len(missingSubSlotDep) > 0:
			missingSubSlotDep = set(missingSubSlotDep)
			print("%s: %s" % (cpv, " ".join(missingSubSlotDep)))

	def _getDepend(self, cpv):
		deps = self.dbapi.aux_get(cpv, ["RDEPEND"])[0]
		result = []
		for dep in deps.split():
			if self._isValidAtom(dep):
				result.append(dep)
		return set(result)

	def _isValidAtom(self, pkg):
		result = False
		try:
			if pkg[0] == "!":
				result = False
			elif pkg.find("/") > 0:
				result = True
		except:
			result = False
		return result

	def _getCP(self, pkg):
		# drop ><= from the beginning
		if pkg[0] in (">", "<", "="):
			pkg = pkg[1:]
		if pkg[0] == "=":
			pkg = pkg[1:]

		dotPos = pkg.find(":")
		bracketPos = pkg.find("[")
		if dotPos > 0:
			pkg = pkg[0:dotPos]
		elif bracketPos > 0:
			pkg = pkg[0:bracketPos]
		res = catpkgsplit(pkg)
		if res:
			return res[0] + "/" + res[1]
		return pkg

	def _isSubSlotDep(self, pkg):
		m = re.search(":[0-9]*?=", pkg)
		return m is not None

	def getPackages(self, trees=None, categories=None):
		if trees is None:
			trees = ["/usr/portage"]
		return self.dbapi.cp_all(categories=categories, trees=trees)

	def getPackageVersions(self, cp):
		return self.dbapi.cp_list(cp)

c = CheckSubSlot()
pkgs = c.getPackages()
for pkg in pkgs:
	cpvs = c.getPackageVersions(pkg)
	for cpv in cpvs:
		c.checkPackage(cpv)

