# Contributing

This repository holds infrastructure pattern documents for a small lab (this folder holds the updated copy of enterprise-infrastructure-lab; copy files into the real repository). Helpful contributions:

- Corrections: a wrong fact, a broken link, an outdated recommendation (say what source shows it).
- A short document or checklist from your own experience, **sanitized** (no company, person, host or address names; see REDACTION.md or the sanitization section of the README).
- Clearer wording or a missing "how to check it works" step.

Rules: one change per pull request; run `python -m unittest discover -s tests` and `python scripts/check_redaction.py .` first; no copied text without a license and citation; no unverifiable claims. Open an issue before anything large. One maintainer, so replies can take a few days.

By contributing you agree that your documents are licensed under CC BY 4.0 and your code under MIT, as described in ATTRIBUTION.md.
