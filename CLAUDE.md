# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal resumes (Vadim Kholodilo), one per folder: [dotnet/](dotnet/) (.NET developer) and [python/](python/) (Python developer, currently a template with no experience entries). Each folder holds **two language versions that must stay in sync**: `resume-en.tex` (English) and `resume-ru.tex` (Russian). All of them `\input{../resume-common}` -- the shared preamble/macros in [resume-common.tex](resume-common.tex) at the repo root (packages, page setup, `\resume*` commands; not a standalone document). There is no application code -- changes are edits to resume content or formatting. **Any content change (a new position, an edited bullet, a skills-list update) must be applied to both language files of the affected resume folder**, translated naturally rather than word-for-word -- see the `new-position` skill. Content is not shared between resumes; a change to `dotnet/` does not automatically apply to `python/`. To add another resume, run `make new NAME=<folder> [FROM=<existing folder>]` (copies both `.tex` files, defaulting to `python/` as the empty template); the Makefile and CI discover it automatically. Only the README download table needs a manual row.

## Commands

Build both PDFs locally via the [Makefile](Makefile) (requires a LaTeX distribution with `latexmk`, e.g. MacTeX/TeX Live):

```bash
make build   # or just `make`; builds every folder
make python  # one resume folder (dotnet or python)
```

Clean build artifacts:

```bash
make clean
```

Equivalently, per-file from inside a folder: `cd dotnet && latexmk -pdf resume-en.tex`. PDFs are written next to their sources.

Aux/build artifacts (`*.aux`, `*.log`, `*.out`, `*.pdf`, etc.) are gitignored — don't commit them.

There is no lint or test suite for this repo.

## Release process

Releases are cut by tagging, not by pushing to a branch. `create_release.sh` creates and pushes a tag in `YYYYmmddHHMMSS` format:

```bash
./create_release.sh
```

This triggers [.github/workflows/build.yml](.github/workflows/build.yml), which only fires on tags matching that 14-digit timestamp pattern. The workflow runs in a `texlive/texlive` container, builds all resumes via `make build` (the same Makefile used locally), creates a GitHub release for the tag, and uploads four PDFs as release assets, named `<folder>-resume-<lang>.pdf` (`dotnet-resume-en.pdf`, `dotnet-resume-ru.pdf`, `python-resume-en.pdf`, `python-resume-ru.pdf`). The README's download table links always point at the *latest* release, so any tag push republishes every resume.

## Content structure of each folder's resume-en.tex / resume-ru.tex

Both documents use the custom commands from `resume-common.tex` (`\resumeSubheading`, `\resumeItem`, `\resumeSubHeadingListStart/End`, etc.) to keep entries consistent — use these macros rather than hand-rolling tabular/itemize markup when adding entries. Sections appear in this order: Education, Experience, Projects (currently commented out via `\begin{comment}`), Programming Skills (`Технические навыки` in the Russian version). The Russian version runs longer per word than English, so keep bullets tight enough to still fit one page — check the compiled page count after edits.

The `python/` Experience section is intentionally empty: the `\resumeSubHeadingListStart/End` wrapper is commented out because an empty `itemize` fails to compile. Uncomment it when adding the first position.
