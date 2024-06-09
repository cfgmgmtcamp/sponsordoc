default all: pdf

TMPDIR:=$(shell mktemp -d /tmp/latex.XXXX)
FIRSTTAG:=$(shell git describe --abbrev=0 --tags --always)
RELTAG:=$(shell git describe --tags --long --always --dirty='-*' --match '[0-9]*.*')

pdf: gitinfo build

build: sponsordoc.tex
	@test -d $(TMPDIR) || mkdir $(TMPDIR)
	@echo "Running 2 compiles $(TMPDIR)"
	@pdflatex -output-directory=$(TMPDIR) -interaction=batchmode -file-line-error -no-shell-escape $< > /dev/null
	@pdflatex -output-directory=$(TMPDIR) -interaction=batchmode -file-line-error -no-shell-escape $< > /dev/null
	@cp $(TMPDIR)/sponsordoc.pdf sponsordoc.pdf
	@echo "Sponsor Document PDF Ready"

.PHONY: gitinfo
gitinfo:
	@git log -1 --date=short --pretty=format:"\usepackage[shash={%h},lhash={%H},authname={%an},authemail={%ae},authsdate={%ad},authidate={%ai},authudate={%at},commname={%an},commemail={%ae},commsdate={%ad},commidate={%ai},commudate={%at},refnames={%d},firsttagdescribe="${FIRSTTAG}",reltag="${RELTAG}"]{gitexinfo}" HEAD > $(TMPDIR)/gitHeadLocal.gin

.PHONY: clean
clean:
	@rm -rf /tmp/latex*
	@rm -f *.pdf
