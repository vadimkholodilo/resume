---
name: new-position
description: Use when adding a new job/position entry to resume.tex, or editing an existing position's bullets. Ensures the entry matches the style of existing entries and that the Programming Skills section stays consistent with what's actually mentioned in Experience bullets.
---

# Adding a position to the resume

## 1. Gather the facts

Ask for whatever isn't already given: company, location, title, start/end dates (format `Mon. YYYY -- Mon. YYYY` or `Mon. YYYY -- Present`, matching existing entries like `Nov. 2023 - May. 2024`), and the raw material for bullets (what they did, tools used, measurable impact).

If the user has a careers-page/job-posting URL and wants help remembering what to write, use the **research-job-posting** skill first to draft candidate bullets from the posting — then come back here with the ones the user confirms are true.

## 2. Write bullets in the house style

Study the existing `\resumeItem` bullets in [resume.tex](../../../resume.tex) before writing new ones. Match:

- **Past tense, action-verb-first** ("Enhanced", "Optimized", "Streamlined", "Implemented", "Collaborated").
- **Quantified impact** where possible — a %, a dollar amount, a time saved (e.g. "achieving 20\% speed increase", "reducing deployment time by 50\%"). Don't invent numbers; ask the user for a real figure or write the bullet without one.
- **Names the specific technology/tool** used, not a vague category (e.g. "integrating Stripe payments with the in-house .NET 6 CRM", not "integrated a payment system").
- One line of substance per bullet, no filler.
- Escape LaTeX special characters: `%` → `\%`, `$` → `\$`, `#` → `\#`, `&` → `\&`.

## 3. Insert in the right place and format

Positions are in **reverse chronological order** (most recent first) inside `\resumeSubHeadingListStart ... \resumeSubHeadingListEnd` under `\section{Experience}`. Insert the new `\resumeSubheading` block at the position matching its dates, using this exact macro shape:

```latex
\resumeSubheading
{Company Name}{City, ST}
{Job Title}{Mon. YYYY -- Mon. YYYY}
\resumeItemListStart
\resumeItem{...}
\resumeItem{...}
\resumeItemListEnd
```

## 4. Enforce the skills-list rule

This is the part that's easy to get wrong silently: **a skill only belongs in the `Programming Skills` section (`Languages` / `Technologies` lists) if it is mentioned by name in at least one bullet somewhere in Experience.**

- If a new bullet mentions a tool/language not currently in `Programming Skills`, add it there.
- Do NOT add a skill to `Programming Skills` just because the user mentions it in conversation — it must appear in actual bullet text in `resume.tex`.
- If editing/removing a bullet causes a skill to no longer be mentioned anywhere in Experience, flag it and ask whether to remove it from `Programming Skills` too.
- **Exceptions** (fine to list even without an explicit bullet mention, because writing a bullet about them would waste space, or because they're too fundamental/ambient to call out): `Git`, `C`, `HTML`, `CSS`, `Bash`, `PowerShell`, `Linux`, `AWS`, `Azure`, `Node.js`. If the user names another skill as an obvious exception, treat it the same way going forward — but don't invent new exceptions unilaterally; ask first.

## 5. Verify

After editing, compile to confirm it's valid LaTeX (per [CLAUDE.md](../../../CLAUDE.md)):

```bash
latexmk -pdf resume.tex
```

Then clean up build artifacts if they're not wanted (they're gitignored, so this is optional):

```bash
latexmk -c
```

Report back which skills (if any) were added to or should be removed from `Programming Skills`, since that's the part most likely to be missed.
