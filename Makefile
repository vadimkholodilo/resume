TEX_FILES := resume-en.tex resume-ru.tex
PDF_FILES := $(TEX_FILES:.tex=.pdf)

.PHONY: all build clean

all: build

build: $(PDF_FILES)

%.pdf: %.tex resume-common.tex
	latexmk -pdf $<

clean:
	latexmk -c $(TEX_FILES)
