WEBSITE=http://www.scripture4all.org
PDFDIR=OnlineInterlinear
HE_INDEX=Hebrew_Index.htm
GR_INDEX=Greek_Index.htm
URL_HE=$(WEBSITE)/$(PDFDIR)/$(HE_INDEX)
URL_GR=$(WEBSITE)/$(PDFDIR)/$(GR_INDEX)
WGET=wget -r -l1 -nH -A pdf -A htm
PDFNAME=interlinear

all: $(PDFNAME).pdf

download-stamp:
	$(WGET) $(URL_HE)
	$(WGET) $(URL_GR)
	touch $@

%.pdf: %.tex
	pdflatex $*

$(PDFDIR)/$(HE_INDEX) $(PDFDIR)/$(GR_INDEX): download-stamp

$(PDFNAME).tex: $(PDFDIR)/$(HE_INDEX) $(PDFDIR)/$(GR_INDEX)
	echo '\\documentclass{scrbook}\\usepackage{pdfpages}\\begin{document}' > $@
	sed -n 's@.*a href="\(.*.pdf\)".*@\\includepdf[pages=-]{$(PDFDIR)/\1}@pg' $(PDFDIR)/$(HE_INDEX) >> $@
	sed -n 's@.*a href="\(.*.pdf\)".*@\\includepdf[pages=-]{$(PDFDIR)/\1}@pg' $(PDFDIR)/$(GR_INDEX) >> $@
	echo '\\end{document}' >> $@

clean:
	rm -f $(PDFNAME).tex
	rm -f $(PDFNAME).pdf
	rm -f $(PDFNAME).aux $(PDFNAME).log
	rm -rf robots.txt $(PDFDIR) download-stamp
