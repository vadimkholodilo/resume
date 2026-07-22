---
name: research-job-posting
description: Use at the start of adding a new position, when the user gives a company careers-page URL (and optionally title/criteria) and wants candidate resume bullet points drafted from real job postings, to jog their memory about what to write. Feeds into the new-position skill.
---

# Researching a job posting to draft resume bullets

Purpose: memory aid, not fabrication. You will produce *draft, unverified* bullet candidates derived from what a job posting says the role expects. The user must confirm each one is actually true of their own experience before it goes anywhere near [resume.tex](../../../resume.tex). Never present a drafted bullet as a fact about the user's history.

## 1. Get the inputs

Required: a careers-page URL. Optional but useful: title keywords, seniority level, location/remote constraint, or any other filter criteria — ask if not given and the page clearly lists multiple unrelated roles.

## 2. Fetch and find matching postings

Prefer a real browser tool if one is available in this environment — run `ToolSearch` for `browser` / `playwright` before starting, since that's more reliable for JS-heavy career sites (Greenhouse, Lever, Workday, etc. often render client-side). If none is available, use `WebFetch` on the careers-page URL, prompting it to list job postings (title + link) matching the given criteria.

**Budget: at most 2 fetch attempts per page** (e.g. one direct fetch, one retry with a more targeted prompt or an obvious alternate URL like `/jobs` or a sitemap). If both fail — empty content, JS shell with no data, paywall/login wall, bot-blocked — **stop immediately**. Do not keep guessing URLs, retrying with variations, or trying to route around blocks. Report exactly what failed and ask the user to paste the job posting text or HTML manually instead. Burning tokens hunting for a workaround is worse than asking.

## 3. No matches

If the page loads fine but nothing matches the given criteria (no open roles, or none matching the title/level/location filter), say so explicitly and stop — don't broaden the criteria on your own or report unrelated postings as if they were relevant.

## 4. Extract requirements from matching postings

For each matching posting, fetch the individual listing (same 2-attempt budget) and pull out the responsibilities/requirements — concrete tools, technologies, and types of work called out, not generic soft-skill filler ("team player," "fast-paced environment").

## 5. Draft candidate bullets

For each concrete requirement/responsibility, draft a bullet framed as a **prompt for the user to confirm**, not an assertion:

```
- [DRAFT — confirm this is true] They emphasize <requirement/tool from posting>. Did you do something like this? e.g. draft bullet: "<action-verb bullet in house style, no invented numbers>"
```

Group drafts by posting/company. Flag which specific tools/technologies appear, since that matters for the Programming Skills consistency rule.

## 6. Hand off

Present the drafts to the user for review. Once they confirm which are true (and supply any real metrics), use the **new-position** skill to write them into `resume.tex` in house style and to reconcile the Programming Skills list. Do not write directly to `resume.tex` from this skill.
