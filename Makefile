
TARGET=main
PDFDIR=pdf

LATEX=pdflatex
BIBTEX=bibtex
SORT=./sort.sh

# Verifique se sua instalação do LaTeX e Ghostscript
# possuem estes comandos:
ifeq ($(LATEX),latex)
DVIPS=dvips
DVIPSOPTS=-P pdf -t a4 -Pdownload35
PS2PDF=ps2pdf -dPDFSETTINGS=/prepress
endif

all: $(TARGET).pdf
	mkdir -p $(PDFDIR)
	mv $< $(PDFDIR)/$<

ifeq ($(LATEX),pdflatex)
$(TARGET).pdf: $(TARGET).tex
else
$(TARGET).pdf: $(TARGET).ps
	$(PS2PDF) $<

$(TARGET).ps: $(TARGET).dvi
	$(DVIPS) $(DVIPSOPTS) -o $@ $<

$(TARGET).dvi: $(TARGET).tex
endif
	$(LATEX) $<
	$(BIBTEX) $(TARGET)
	$(LATEX) $<
	$(SORT) $(TARGET)
	$(LATEX) $<

clean: SHELL:=/bin/bash
clean: 
	rm -f *.{aux,fdb_latexmk,fls,gz,log,bbl,blg,out,toc,loa,lob,lov,lof,los,lot,dvi,ps,pdf}
