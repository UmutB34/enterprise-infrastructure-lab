# ADR 0002: Privacy-minimised first-party measurement

- **Status:** Accepted (implementation awaiting release approval)
- **Date:** 2026-10-27

## Context

The product needed to answer which domains are scanned and whether traffic is human. Page-view analytics could not say, hosting logs expire within about an hour on the current tier, and the first measured traffic was too small to tell people from bots by volume alone.

## Decision

Record one minimal event per completed public action in the product's own database: registered domain, outcome, score range, duration, country, device class, referring site name, language, a bot score and a day-specific visitor pseudonym. Do not store addresses, user-agent text, cookies or account identifiers with it. Delete rows after 90 days. Update the privacy notice together with the code.

## Consequences

- Questions about use and bots can be answered from data the lab owns.
- The registered domain is stored in clear text, which makes a list of scan subjects. This is a deliberate trade-off against an earlier rule that stored such keys only as hashes. It is acceptable only with a short retention, closed access and an honest notice.
- Measurement adds one best-effort write after the response. It must never delay or fail a scan.
- Applying the schema to production needs a human.

## Alternatives considered

- **Third-party analytics only.** Rejected: cannot show the scanned subject or separate bots reliably.
- **Hashed domains only.** Rejected for now: it hides exactly the question being asked; revisit if the notice or a legal review requires it.
- **Keep raw IP addresses for bot detection.** Rejected: more personal data than the question needs.
