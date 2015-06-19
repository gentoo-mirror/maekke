#!/usr/bin/env python

import io
import os
import sys
from repoman.checks import run_checks

class DummyPkg:
	def __init__(self, name):
		self.name = name
		self.mtime = None
		self.eapi = 0
		self.inherited = ''

class RepoClass:
	def __init__(self):
		self._repodir = None

	def run(self, repodir=None):
		self._repodir = repodir
		eclasses = self._getEclasses()
		self._runChecks(eclasses)

	def _getEclasses(self):
		eclasses = []
		eclassdir = os.path.join(self._repodir, 'eclass')
		for file in os.listdir(eclassdir):
			if file.endswith('.eclass'):
				eclasses.append(os.path.join(eclassdir, file))
		eclasses.sort()
		return eclasses

	def _runChecks(self, eclasses):
		for eclass in eclasses:
			pkg = DummyPkg(eclass)
			f = io.open(eclass, mode='r')
			try:
				for check_name, e in run_checks(f, pkg):
					if not e.startswith('valid EAPI assignment must occur on or before line'):
						print '%s --> %s: %s' % (os.path.basename(eclass), check_name, e)
			finally:
				f.close()

rc = RepoClass()
rc.run(repodir=sys.argv[1])
