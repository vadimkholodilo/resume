TEX_FILES := resume-en.tex resume-ru.tex
PDF_FILES := $(TEX_FILES:.tex=.pdf)
ATS_REPORT := resume-en-ats-report.md

.PHONY: all build clean report

all: build

build: $(PDF_FILES)

%.pdf: %.tex resume-common.tex
	latexmk -pdf $<

clean:
	latexmk -c $(TEX_FILES)

report: $(ATS_REPORT)

$(ATS_REPORT): resume-en.tex
	claude -p "/resume-ats-optimizer Analyze resume-en.tex against general ATS best practices (no specific job posting to compare against). Save the full report -- score breakdown, issues found, and concrete recommended changes -- to $(ATS_REPORT) in the current directory, overwriting it if it already exists." \
		--allowedTools "Read Grep Glob Skill Write"
