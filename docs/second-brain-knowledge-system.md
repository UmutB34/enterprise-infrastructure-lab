# A personal knowledge system (second brain)

Design notes for a self-hosted knowledge base. No host names, addresses, credentials or personal data are described.

## Goal

Keep decisions, learnings and project context in one place that survives across tools and sessions, so work can resume without re-explaining everything.

## Structure

- A notes vault organized by purpose: projects, management, research, decisions, learnings, infrastructure, AI sessions, archive.
- An index note that links to everything important.
- Notes link to canonical documents instead of copying them, so there is one source of truth.
- A short decision register with an age and status for each open question.

## Rules that keep it trustworthy

1. **No secrets in notes.** Keys, tokens and passwords never enter the vault.
2. **One clock.** All dates and times use one agreed time zone and one format.
3. **Facts have sources.** A claim links to the document or output that supports it.
4. **Summaries, not duplicates.** A note summarizes and links; it never becomes a second copy of a technical document.
5. **Daily close.** A short end-of-day note records what changed and what carries over.
6. **Live proof over old notes.** When a note and the live system disagree, the live check wins and the note is corrected.

## Retrieval

Search combines keyword ranking with meaning-based (vector) search and merges the two rankings, so exact terms and related ideas both surface. Every result points back to its source note so it can be checked.

## Sync and safety

- The vault is synchronized between machines with a file-sync tool that keeps versions.
- Scheduled jobs archive processed inbox items, so the system does not stall at its own limits.
- Agents read from the vault before starting a task and write results back with their evidence.

## What I learned

- Writing a rule down once is worth more than remembering it ten times.
- A knowledge base that is not kept current is worse than none; the daily close is what keeps it alive.
- Linking beats copying every time.
