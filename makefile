SVG = $(wildcard svg/*.svg)
PDF = $(SVG:svg/%.svg=pdf/%.pdf)

all: $(PDF) kms-whitepaper.pdf kms-whitepaper.lof

kms-whitepaper.pdf:	kms-whitepaper.lof
		bibtex kms-whitepaper && pdflatex -halt-on-error kms-whitepaper.tex && pdflatex -halt-on-error kms-whitepaper.tex && rm -f *.aux *.log *.blg *.toc *.out
kms-whitepaper.lof:	*.tex
		pdflatex -halt-on-error kms-whitepaper.tex
$(PDF):	pdf/%.pdf: svg/%.svg
		inkscape "$<" --export-pdf="$@"

arxiv:	$(PDF) kms-whitepaper.pdf kms-whitepaper.lof
		tar -czf kms-whitepaper.tar.gz kms-whitepaper.tex kms-whitepaper.bbl pdf/
