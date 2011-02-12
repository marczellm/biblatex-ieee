################################################################
################################################################
# Makefile for "biblatex-ieee"                                 #
################################################################
################################################################

.SILENT:

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make clean        - remove generated files"
	@echo " make ctan         - create archive for CTAN"
	@echo " make doc          - create documentation"  
	@echo " make localinstall - install files in local texmf tree"
	@echo " make tds          - make TDS-ready archive"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = biblatex-ieee

##############################################################
# Directory structure for making zip files                   #
##############################################################

CTANROOT := ctan
CTANDIR  := $(CTANROOT)/$(PACKAGE)
TDSDIR   := tds

##############################################################
# Data for local installation and TDS construction           #
##############################################################

INCLUDEPDF  := $(PACKAGE)
INCLUDETEX  :=
INCLUDETXT  := README
PACKAGEROOT := latex/$(PACKAGE)

##############################################################
# Clean-up information                                       #
##############################################################

AUXFILES = \
	aux  \
	bbl  \
	bcf  \
	blg  \
	cmds \
	glo  \
	gls  \
	hd   \
	idx  \
	ilg  \
	ind  \
	log  \
	out  \
	tmp  \
	toc  \
	xml
		
CLEAN = \
	gz  \
	ins \
	pdf \
	sty \
	txt \
	zip 

DOCS     = 
STYLES   = ieee
TDS      = latex/$(PACKAGE)

# Even if files exist, use the rules here

.PHONY: clean ctan doc localinstall help tds

# The business end

clean:
	for I in $(AUXFILES) $(CLEAN) ; do \
      rm -rf *.$$I ; \
	done
	for I in $(STYLES) ; do \
	  rm -rf biblatex-$$I-blx.bib ; \
	done 

ctan: tds
	echo "Making CTAN zip file"
	mkdir -p tmp/
	rm -rf tmp/*
	mkdir -p tmp/$(PACKAGE)
	for I in $(DOCS) ; do \
	  cp $$I.bib tmp/$(PACKAGE) ; \
	  cp $$I.pdf tmp/$(PACKAGE) ; \
	  cp $$I.tex tmp/$(PACKAGE) ; \
	done
	for I in $(STYLES) ; do \
	  cp $$I.bbx tmp/$(PACKAGE) ; \
	  cp $$I.cbx tmp/$(PACKAGE) ; \
	  cp biblatex-$$I.pdf tmp/$(PACKAGE) ; \
	  cp biblatex-$$I.tex tmp/$(PACKAGE) ; \
	done
	cp README tmp/$(PACKAGE)
	cp README tmp/$(PACKAGE)
	cp $(PACKAGE).tds.zip tmp/
	cd tmp ; \
	zip -ll -q -r -X ../$(PACKAGE).zip .
	rm -rf tmp

doc:
	echo "Compiling documents"
	for I in $(DOCS) ; do \
	  pdflatex -draftmode -interaction=batchmode $$I &> /dev/null ; \
	  bibtex8 --wolfgang $$I                         &> /dev/null ; \
	  pdflatex -interaction=batchmode $$I            &> /dev/null ; \
	  rm -rf $$I-blx.bib ; \
	done
	for I in $(STYLES) ; do \
	  pdflatex -draftmode -interaction=batchmode biblatex-$$I &> /dev/null ; \
	  bibtex8 --wolfgang biblatex-$$I                         &> /dev/null ; \
	  pdflatex -interaction=batchmode biblatex-$$I            &> /dev/null ; \
	  rm -rf biblatex-$$I-blx.bib ; \
	done
	for I in $(AUXFILES) ; do \
	  rm -rf *.$$I ; \
	done  

localinstall:
	echo "Installing files"
	TEXMFHOME=`kpsewhich --var-value=TEXMFHOME` ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT) ; \
	rm -rf $$TEXMFHOME/tex/$(PACKAGEROOT)/* ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT) ; \
	cp *.bbx $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	cp *.cbx $$TEXMFHOME/tex/$(PACKAGEROOT)/
	
tds: doc
	echo "Making TDS structure"
	mkdir -p tds/
	rm -rf tds/*
	mkdir -p tds/tex/$(TDS)
	mkdir -p tds/doc/$(TDS)
	for I in $(DOCS) ; do \
	  cp $$I.bib tds/doc/$(TDS)/ ; \
	  cp $$I.pdf tds/doc/$(TDS)/ ; \
	  cp $$I.tex tds/doc/$(TDS)/ ; \
	done
	for I in $(STYLES) ; do \
	  cp $$I.bbx tds/tex/$(TDS)/ ; \
	  cp $$I.cbx tds/tex/$(TDS)/ ; \
	  cp biblatex-$$I.pdf tds/doc/$(TDS)/ ; \
	  cp biblatex-$$I.tex tds/doc/$(TDS)/ ; \
	done
	cp README tds/doc/$(TDS)/
	cd tds ; \
	zip -ll -q -r -X ../$(PACKAGE).tds.zip .
	rm -rf tds