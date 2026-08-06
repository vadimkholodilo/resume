# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal resume (Vadim Kholodilo), maintained in **two language versions** that must stay in sync: [resume-en.tex](resume-en.tex) (English) and [resume-ru.tex](resume-ru.tex) (Russian). Both `\input` the shared preamble/macros in [resume-common.tex](resume-common.tex) — that file holds packages, page setup, and the `\resume*` custom commands, and is not a standalone document. There is no application code — changes here are almost always edits to resume content or formatting. **Any content change (a new position, an edited bullet, a skills-list update) must be applied to both `resume-en.tex` and `resume-ru.tex`**, translated naturally rather than word-for-word — see the `new-position` skill.

## Commands

Build both PDFs locally via the [Makefile](Makefile) (requires a LaTeX distribution with `latexmk`, e.g. MacTeX/TeX Live):

```bash
make build   # or just `make`
```

Clean build artifacts:

```bash
make clean
```

Equivalently, per-file: `latexmk -pdf resume-en.tex` / `latexmk -pdf resume-ru.tex`.

Aux/build artifacts (`*.aux`, `*.log`, `*.out`, `*.pdf`, etc.) are gitignored — don't commit them.

There is no lint or test suite for this repo.

## Release process

Releases are cut by tagging, not by pushing to a branch. `create_release.sh` creates and pushes a tag in `YYYYmmddHHMMSS` format:

```bash
./create_release.sh
```

This triggers [.github/workflows/build.yml](.github/workflows/build.yml), which only fires on tags matching that 14-digit timestamp pattern. The workflow runs in a `texlive/texlive` container, builds both `resume-en.tex` and `resume-ru.tex` via `make build` (the same Makefile used locally), creates a GitHub release for the tag, and uploads `resume-en.pdf` and `resume-ru.pdf` as release assets. The README's "Download PDF" links always point at the *latest* release, so any tag push effectively republishes both resumes.

## Content structure of resume-en.tex / resume-ru.tex

Both documents use the custom commands from `resume-common.tex` (`\resumeSubheading`, `\resumeItem`, `\resumeSubHeadingListStart/End`, etc.) to keep entries consistent — use these macros rather than hand-rolling tabular/itemize markup when adding entries. Sections appear in this order: Education, Experience, Projects (currently commented out via `\begin{comment}`), Programming Skills (`Технические навыки` in the Russian version). The Russian version runs longer per word than English, so keep bullets tight enough to still fit one page — check the compiled page count after edits.
