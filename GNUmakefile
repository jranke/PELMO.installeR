PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
TGZ     := $(PKGNAME)_$(PKGVERS).tar.gz
R_HOME  ?= $(shell R RHOME)
DATE    := $(shell date +%Y-%m-%d)

.PHONY: check

pkgfiles = DESCRIPTION \
		 .Rbuildignore \
	   docs/* \
		 docs/reference/* \
	   R/*

roxygen:
	@echo "Roxygenizing package..."
	"$(R_HOME)/bin/Rscript" -e 'library(devtools); document()'
	@echo "DONE."

pd: roxygen
	@echo "Building static documentation..."
	"$(R_HOME)/bin/Rscript" -e 'pkgdown::build_site()'
	@echo "DONE."

$(TGZ): $(pkgfiles)
	sed -i -e "s/Date:.*/Date: $(DATE)/" DESCRIPTION
	@echo "Roxygenizing package..."
	"$(R_HOME)/bin/Rscript" -e 'library(devtools); document()'
	@echo "Building package..."
	git log --no-merges -M --date=iso > ChangeLog
	"$(R_HOME)/bin/R" CMD build . > build.log 2>&1
	@echo "DONE."

build: $(TGZ)

check: build
	@echo "Running CRAN check..."
	"$(R_HOME)/bin/R" CMD check --as-cran $(TGZ)
	@echo "DONE."

install: build
	@echo "Installing package..."
	"$(R_HOME)/bin/R" CMD INSTALL --no-multiarch $(TGZ)
	@echo "DONE."

drat: build
	"$(R_HOME)/bin/Rscript" -e "drat::insertPackage('$(TGZ)', commit = TRUE)"
