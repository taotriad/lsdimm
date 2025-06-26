# lsdimm

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/taotriad/lsdimm/badge)](https://securityscorecards.dev/viewer/?uri=github.com/taotriad/lsdimm)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/taotriad/lsdimm/main)
![GitHub commits since tagged version](https://img.shields.io/github/commits-since/taotriad/lsdimm/v0.0.0/main)

__lsdimm__ is a wrapper around [dmidecode](https://www.nongnu.org/dmidecode/)
that summarises the memory population
in a system in a way that's more concise than what's offered by __dmidecode__.

Since __dmidecode__ requires root privileges this script requires that too;
either by running the command as _root_, or by using `sudo`.  Under no
circumstances should you use this as a _suid_-executable; this program
has __not__ been audited for such use, nor is it ever likely to be.

Note that this project is in an early stage of development; it has not
reached its first minor version yet. While it has been tested with
a variety of configurations, there are no test cases beyond
the code standards checks, and it's unlikely to handle various I/O errors
in a clean way.

Do **not** use this script in production environments.
