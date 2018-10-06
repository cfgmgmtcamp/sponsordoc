default all: pdf

TMPDIR="/tmp"

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

pdf: presentation handouts

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
