default all: pdf

TMPDIR:=$(shell mktemp -d /tmp/latex.XXXX)
FIRSTTAG:=$(shell git describe --tags --always --dirty='-*')
RELTAG:=$(shell git describe --tags --long --always --dirty='-*' --match '[0-9]*.*')


dvi: presentation.tex
	latex '\nonstopmode \input presentation'

presentation: sponsordoc-presentation.tex
	@test -d $(TMPDIR) || mkdir $(TMPDIR)
	@echo "Running 2 compiles"
	@pdflatex -output-directory=$(TMPDIR) -interaction=batchmode -file-line-error -no-shell-escape $< > /dev/null
	@pdflatex -output-directory=$(TMPDIR) -interaction=batchmode -file-line-error -no-shell-escape $< > /dev/null
	@cp $(TMPDIR)/sponsordoc-presentation.pdf sponsordoc-presentation.pdf
	@echo "Presentation PDF Ready"

handouts: sponsordoc.tex
	@test -d $(TMPDIR) || mkdir $(TMPDIR)
	@echo "Running 2 compiles"
	@pdflatex -output-directory=$(TMPDIR) -interaction=batchmode -file-line-error $< > /dev/null
	@pdflatex -output-directory=$(TMPDIR) -interaction=batchmode -file-line-error $< > /dev/null
	@cp $(TMPDIR)/sponsordoc.pdf sponsordoc.pdf
	@echo "Presentation PDF Ready"

.PHONY:gitinfo
gitinfo:
	git log -1 --date=short --pretty=format:"\usepackage[shash={%h},lhash={%H},authname={%an},authemail={%ae},authsdate={%ad},authidate={%ai},authudate={%at},commname={%an},commemail={%ae},commsdate={%ad},commidate={%ai},commudate={%at},refnames={%d},firsttagdescribe="${FIRSTTAG}",reltag="${RELTAG}"]{gitexinfo}" HEAD > $(TMPDIR)/gitHeadLocal.gin

pdf: gitinfo presentation handouts

html: presentation.tex texi2html
	texi2html -split_node -menu $<
	makeinfo --number-sections --html --no-split $<

check:
	dw <tds.tex
	#chkdelim <tds.tex
	ispell -t -l <tds.tex | sort -u

clean: presentation.tex
	@rm -rf $(TMPDIR)
	@rm -rf $(TMPDIR)
	@rm -f sponsordoc.pdf
	@rm -f sponsordoc-presentation.pdf
