# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal resume (Vadim Kholodilo) written as a single LaTeX file, [resume.tex](resume.tex). There is no application code — changes here are almost always edits to resume content or formatting within that one file.

## Commands

Build the PDF locally (requires a LaTeX distribution with `latexmk`/`pdflatex`, e.g. MacTeX/TeX Live):

```bash
latexmk -pdf resume.tex
```

or directly:

```bash
pdflatex resume.tex
```

Aux/build artifacts (`*.aux`, `*.log`, `*.out`, `*.pdf`, etc.) are gitignored — don't commit them.

There is no lint or test suite for this repo.

## Release process

Releases are cut by tagging, not by pushing to a branch. `create_release.sh` creates and pushes a tag in `YYYYmmddHHMMSS` format:

```bash
./create_release.sh
```

This triggers [.github/workflows/build.yml](.github/workflows/build.yml), which only fires on tags matching that 14-digit timestamp pattern. The workflow compiles `resume.tex` with `xu-cheng/latex-action`, creates a GitHub release for the tag, and uploads `resume.pdf` as a release asset. The README's "Download PDF" link always points at the *latest* release, so any tag push effectively republishes the resume.

## Content structure of resume.tex

The document uses custom commands defined near the top (`\resumeSubheading`, `\resumeItem`, `\resumeSubHeadingListStart/End`, etc.) to keep entries consistent — use these macros rather than hand-rolling tabular/itemize markup when adding entries. Sections appear in this order: Education, Experience, Projects (currently commented out via `\begin{comment}`), Programming Skills.
