---
name: new-position
description: Use when adding a new job/position entry to resume-en.tex, or editing an existing position's bullets. Ensures the entry matches the style of existing entries, is mirrored into resume-ru.tex, and that the Programming Skills section stays consistent with what's actually mentioned in Experience bullets — in both language versions.
---

# Adding a position to the resume

**This resume has two language versions that must stay in sync: [resume-en.tex](../../../resume-en.tex) (English) and [resume-ru.tex](../../../resume-ru.tex) (Russian).** Every step below applies to both files — write/edit the English bullets first, then translate them into natural, resume-appropriate Russian (not a literal word-for-word translation; keep the same house style described in step 2, adapted to Russian phrasing). Shared packages/macros live in [resume-common.tex](../../../resume-common.tex) — don't duplicate them into either language file.

## 1. Gather the facts

Ask for whatever isn't already given: company, location, title, start/end dates (format `Mon. YYYY -- Mon. YYYY` or `Mon. YYYY -- Present`, matching existing entries like `Nov. 2023 - May. 2024`), and the raw material for bullets (what they did, tools used, measurable impact).

If the user has a careers-page/job-posting URL and wants help remembering what to write, use the **research-job-posting** skill first to draft candidate bullets from the posting — then come back here with the ones the user confirms are true.

## 2. Write bullets in the house style

Study the existing `\resumeItem` bullets in [resume-en.tex](../../../resume-en.tex) before writing new ones. Match:

- **Past tense, action-verb-first** ("Enhanced", "Optimized", "Streamlined", "Implemented", "Collaborated").
- **Quantified impact** where possible — a %, a dollar amount, a time saved (e.g. "achieving 20\% speed increase", "reducing deployment time by 50\%"). Don't invent numbers; ask the user for a real figure or write the bullet without one.
- **Names the specific technology/tool** used, not a vague category (e.g. "integrating Stripe payments with the in-house .NET 6 CRM", not "integrated a payment system").
- One line of substance per bullet, no filler.
- Escape LaTeX special characters: `%` → `\%`, `$` → `\$`, `#` → `\#`, `&` → `\&`.

## 3. Insert in the right place and format

Positions are in **reverse chronological order** (most recent first) inside `\resumeSubHeadingListStart ... \resumeSubHeadingListEnd` under `\section{Experience}` (`\section{Опыт работы}` in the Russian file). Insert the new `\resumeSubheading` block at the position matching its dates, using this exact macro shape, in **both** `resume-en.tex` and `resume-ru.tex`:

```latex
\resumeSubheading
{Company Name}{City, ST}
{Job Title}{Mon. YYYY -- Mon. YYYY}
\resumeItemListStart
\resumeItem{...}
\resumeItem{...}
\resumeItemListEnd
```

Company names typically stay in Latin script in the Russian version too (e.g. `Pyrus`, `Build Logics`); translate the city, job title, and bullets. Dates use the same `Mon. YYYY -- Mon. YYYY` shape with Russian month abbreviations (Янв., Февр., Март, Апр., Май, Июн., Июл., Авг., Сент., Окт., Нояб., Дек.).

## 4. Enforce the skills-list rule

This is the part that's easy to get wrong silently: **a skill only belongs in the `Programming Skills` section (`Языки программирования` / `Технологии` in Russian) if it is mentioned by name in at least one bullet somewhere in Experience.** This rule and its tech-name list must match between `resume-en.tex` and `resume-ru.tex` — technology/tool names stay the same (untranslated) in both, only the section/category labels are translated.

- If a new bullet mentions a tool/language not currently in `Programming Skills`, add it there — in both files.
- Do NOT add a skill to `Programming Skills` just because the user mentions it in conversation — it must appear in actual bullet text.
- If editing/removing a bullet causes a skill to no longer be mentioned anywhere in Experience, flag it and ask whether to remove it from `Programming Skills` too (in both files).
- **Exceptions** (fine to list even without an explicit bullet mention, because writing a bullet about them would waste space, or because they're too fundamental/ambient to call out): `Git`, `C`, `HTML`, `CSS`, `Bash`, `PowerShell`, `Linux`, `AWS`, `Azure`, `Node.js`. If the user names another skill as an obvious exception, treat it the same way going forward — but don't invent new exceptions unilaterally; ask first.

## 5. Verify

After editing, compile **both** files to confirm they're valid LaTeX (per [CLAUDE.md](../../../CLAUDE.md)):

```bash
make build
```

Check the log (or `grep -i "output written" resume-ru.log`) for the page count — Russian text runs longer than English, so a new bullet can silently push `resume-ru.tex` onto a second page even when `resume-en.tex` still fits on one. If it overflows, tighten the Russian wording (shorter phrasing, drop redundant qualifiers) rather than shrinking fonts/margins.

Then clean up build artifacts if they're not wanted (they're gitignored, so this is optional):

```bash
make clean
```

Report back which skills (if any) were added to or should be removed from `Programming Skills` in both files, since that's the part most likely to be missed.
