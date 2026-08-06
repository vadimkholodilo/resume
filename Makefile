TEX_FILES := resume-en.tex resume-ru.tex
PDF_FILES := $(TEX_FILES:.tex=.pdf)
ATS_REPORT := resume-en-ats-report.md
ATS_SOURCE := resume-en.ats.tex

.PHONY: all build clean report

all: build

build: $(PDF_FILES)

%.pdf: %.tex resume-common.tex
	latexmk -pdf $<

clean:
	latexmk -c $(TEX_FILES)
	rm -f $(ATS_SOURCE)

report: $(ATS_REPORT)

# Strip commented-out (\begin{comment}...\end{comment}) sections before
# analysis -- they're not part of the compiled PDF, so an ATS or recruiter
# never sees them, and reading them just burns tokens/time for no benefit.
$(ATS_SOURCE): resume-en.tex
	sed '/\\begin{comment}/,/\\end{comment}/d' resume-en.tex > $(ATS_SOURCE)

$(ATS_REPORT): $(ATS_SOURCE)
	claude -p "/resume-ats-optimizer Analyze $(ATS_SOURCE), which is resume-en.tex with its commented-out/inactive sections already stripped out -- treat it as equivalent to resume-en.tex for scoring purposes, and phrase any suggested edits as changes to resume-en.tex (the LaTeX content besides the removed comments is byte-for-byte identical). Evaluate against general ATS best practices (no specific job posting to compare against). Save the full report -- score breakdown, issues found, and concrete recommended changes -- to $(ATS_REPORT) in the current directory, overwriting it if it already exists." \
		--allowedTools "Read Grep Glob Skill Write"
