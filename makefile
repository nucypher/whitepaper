SVG = $(wildcard svg/*.svg)
PDF = $(SVG:svg/%.svg=pdf/%.pdf)

all: $(PDF) whitepaper.pdf whitepaper.lof

whitepaper.pdf:	whitepaper.lof
		bibtex whitepaper && pdflatex -halt-on-error whitepaper.tex && pdflatex -halt-on-error whitepaper.tex && rm -f *.aux *.log *.blg *.toc *.out
whitepaper.lof:	*.tex
		pdflatex -halt-on-error whitepaper.tex
$(PDF):	pdf/%.pdf: svg/%.svg
		inkscape "$<" --export-pdf="$@"

arxiv:	$(PDF) whitepaper.pdf whitepaper.lof
		tar -czf whitepaper.tar.gz whitepaper.tex whitepaper.bbl pdf/
