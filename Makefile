# Each resume lives in its own folder (dotnet/, python/) with a resume-en.tex
# and resume-ru.tex. Shared preamble/macros are in resume-common.tex.
# Any top-level folder containing a resume-en.tex is picked up automatically.
RESUMES := $(patsubst %/resume-en.tex,%,$(wildcard */resume-en.tex))
TEX_FILES := $(foreach r,$(RESUMES),$(r)/resume-en.tex $(r)/resume-ru.tex)
PDF_FILES := $(TEX_FILES:.tex=.pdf)

.PHONY: all build dist clean report new $(RESUMES)

all: build

build: $(PDF_FILES)

# Collect every PDF as dist/<folder>-resume-<lang>.pdf (the release asset names)
dist: build
	mkdir -p dist
	for f in $(PDF_FILES); do cp $$f dist/$$(dirname $$f)-$$(basename $$f); done

# Create a new resume folder from an existing one:
#   make new NAME=golang            (copies from python, the empty template)
#   make new NAME=golang FROM=dotnet
FROM ?= python

new:
	@test -n "$(NAME)" || { echo "usage: make new NAME=<folder> [FROM=<existing folder>]"; exit 1; }
	@test -f "$(FROM)/resume-en.tex" || { echo "error: no resume in '$(FROM)/'"; exit 1; }
	@test ! -e "$(NAME)" || { echo "error: '$(NAME)' already exists"; exit 1; }
	mkdir "$(NAME)"
	cp "$(FROM)/resume-en.tex" "$(FROM)/resume-ru.tex" "$(NAME)/"
	@echo "Created $(NAME)/ from $(FROM)/. Next: edit its .tex files and add a row to the README download table."

# Build a single resume folder, e.g. `make python`
$(RESUMES): %: %/resume-en.pdf %/resume-ru.pdf

# latexmk runs inside the folder so output lands next to the source;
# the sources reach the shared preamble via \input{../resume-common}.
%.pdf: %.tex resume-common.tex
	cd $(dir $<) && latexmk -pdf -interaction=nonstopmode $(notdir $<)

clean:
	for f in $(TEX_FILES); do (cd $$(dirname $$f) && latexmk -c $$(basename $$f)); done
	rm -f */*.ats.tex
	rm -rf dist

# ATS analysis, per resume: `make report` (all) or `make dotnet/resume-en-ats-report.md`
ATS_REPORTS := $(foreach r,$(RESUMES),$(r)/resume-en-ats-report.md)

report: $(ATS_REPORTS)

# Strip commented-out (\begin{comment}...\end{comment}) sections before
# analysis -- they're not part of the compiled PDF, so an ATS or recruiter
# never sees them, and reading them just burns tokens/time for no benefit.
%/resume-en.ats.tex: %/resume-en.tex
	sed '/\\begin{comment}/,/\\end{comment}/d' $< > $@

%/resume-en-ats-report.md: %/resume-en.ats.tex
	claude -p "/resume-ats-optimizer Analyze $<, which is $*/resume-en.tex with its commented-out/inactive sections already stripped out -- treat it as equivalent to $*/resume-en.tex for scoring purposes, and phrase any suggested edits as changes to $*/resume-en.tex (the LaTeX content besides the removed comments is byte-for-byte identical). Evaluate against general ATS best practices (no specific job posting to compare against). Save the full report -- score breakdown, issues found, and concrete recommended changes -- to $@ overwriting it if it already exists." \
		--allowedTools "Read Grep Glob Skill Write"
