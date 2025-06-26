# F841 is the warning about unused assignments.
# flake8 doesn't recognise "_<variable>" to capture unused return values;
# pylint does, so we rely on that one to handle it instead.
# W503 is for line break before binary operator;
# flake8 warns *both* for breaks before and after.
# Hence we we need to ignore one of those warnings.
FLAKE8_IGNORE := F841,W503

# Used by ruff to check for future and/or deprecated features
RUFF_PYTHON_VERSION := py39

# Used by pylint to check for future and/or deprecated features
PYLINT_PYTHON_VERSION := 3.9

# W0511 is TODO/XXX/FIXME; we know that these are things that we should fix eventually.
# Hence we do not need warnings about them.
PYLINT_DISABLE := W0511

# Warn about useless disable
PYLINT_ENABLE := useless-suppression

MYPY_FLAGS := --follow-imports silent --explicit-package-bases --ignore-missing --disallow-untyped-calls --disallow-untyped-defs --disallow-incomplete-defs --check-untyped-defs --disallow-untyped-decorators --warn-redundant-casts --warn-unused-ignores


bin: checks
	@mkdir -p bin && devtools/mangle_source.py lsdimm > bin/lsdimm && chmod a+x bin/lsdimm

clean:
	@rm bin/lsdimm

python_executables = \
	lsdimm \
	devtools/mangle_source.py

checks: ruff flake8 pylint bandit mypy regexploit

bandit:
	@cmd=bandit ;\
	if ! command -v $$cmd > /dev/null 2> /dev/null; then \
		printf -- "\n\n$$cmd not installed; skipping.\n\n\n" ;\
		exit 0 ;\
	fi ;\
	printf -- "\n\nRunning bandit to check for common security issues in Python code\n\n" ;\
	$$cmd -c .bandit $(python_executables)

ruff:
	@cmd=ruff ;\
	if ! command -v $$cmd > /dev/null 2> /dev/null; then \
		printf -- "\n\n$$cmd not installed; skipping.\n\n\n" ;\
		exit 0 ;\
	fi ;\
	printf -- "\n\nRunning $$cmd to check Python code quality\n\n" ;\
	for file in $(python_executables); do \
		case $$file in \
		'noxfile.py') \
			continue;; \
		esac ;\
		printf -- "File: $$file\n" ;\
		$$cmd check --target-version $(RUFF_PYTHON_VERSION) $$file ;\
	done

pylint:
	@cmd=pylint ;\
	if ! command -v $$cmd > /dev/null 2> /dev/null; then \
		printf -- "\n\n$$cmd not installed; skipping.\n\n\n" ;\
		exit 0 ;\
	fi ;\
	printf -- "\n\nRunning pylint to check Python code quality\n\n" ;\
	for file in $(python_executables); do \
		case $$file in \
		'noxfile.py') \
			continue;; \
		esac ;\
		printf -- "File: $$file\n" ;\
		PYTHONPATH=. $$cmd --py-version $(PYLINT_PYTHON_VERSION) --disable $(PYLINT_DISABLE) --enable $(PYLINT_ENABLE) $$file ;\
	done

flake8:
	@cmd=flake8 ;\
	if ! command -v $$cmd > /dev/null 2> /dev/null; then \
		printf -- "\n\n$$cmd not installed; skipping.\n\n\n" ;\
		exit 0 ;\
	fi ;\
	printf -- "\n\nRunning flake8 to check Python code quality\n\n" ;\
	$$cmd --ignore $(FLAKE8_IGNORE) --max-line-length 100 --statistics $(python_executables) && printf -- "OK\n\n" ;\
	printf -- "\n\nRunning flake8 to check Python test case code quality\n\n" ;\
	$$cmd --ignore $(FLAKE8_IGNORE) --max-line-length 100 --statistics $(python_test_executables) && printf -- "OK\n\n"

regexploit:
	@cmd=regexploit-py ;\
	if ! command -v $$cmd > /dev/null 2> /dev/null; then \
		printf -- "\n\n$$cmd not installed (install with 'pipx install regexploit' or pipx install --proxy <proxy> regexploit'); skipping.\n\n\n" ;\
		exit 0 ;\
	fi ;\
	printf -- "\n\nRunning regexploit to check for ReDoS attacks\n\n" ;\
	printf -- "Checking executables\n" ;\
	$$cmd $(python_executables) && printf -- "OK\n\n"

# Note: we know that the code does not have complete type-hinting,
# hence we return 0 after each test to avoid it from stopping.
mypy:
	@cmd=mypy ;\
	if ! command -v $$cmd > /dev/null 2> /dev/null; then \
		printf -- "\n\n$$cmd not installed; skipping.\n\n\n"; \
		exit 0; \
	fi; \
	printf -- "\n\nRunning mypy to check Python typing\n\n"; \
	for file in $(python_executables); do \
		$$cmd $(MYPY_FLAGS) $$file || true; \
	done
