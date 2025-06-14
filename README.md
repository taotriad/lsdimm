# lsdimm

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/intel/cluster-management-toolkit/badge)](https://securityscorecards.dev/viewer/?uri=github.com/intel/cluster-management-toolkit)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/intel/cluster-management-toolkit/main)
![GitHub commits since tagged version](https://img.shields.io/github/commits-since/intel/cluster-management-toolkit/v0.8.5/main)

__lsdimm__ is a wrapper around [dmidecode](https://www.nongnu.org/dmidecode/)
that summarises the memory DIMM population
in a system in a way that's more concise than what's offered by __dmidecode__.

Since __dmidecode__ requires root privileges this script requires that too;
either by running the command as _root_, or by using 'sudo'.  Under no
circumstances should you use this as a _suid_-executable; this program
has __not__ been audited for such use.

Note that this project is a *very* early draft. It has not been tested for
any corner cases and is very likely to crash if it encounters a configuration
it doesn't expect. Do **not** use this script in production environments.
