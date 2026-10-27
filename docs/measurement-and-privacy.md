# Product measurement with privacy by design

How a small product learns who uses it, and from where, without storing who they are. The same pattern fits any public tool that must tell real use from automated traffic.

## The problem

- Page-view analytics count visits, but cannot say which input was used or whether a visit was a person or a bot.
- A hosting platform's request logs are short-lived on lower tiers (about an hour), so questions asked later cannot be answered from logs.
- Counting visitors is a vanity metric. The numbers that matter are completed actions: a finished scan, a sign-up, a payment.

Measurement therefore has to be designed in, not recovered afterwards.

## What is recorded

One row per completed public action, written by trusted server code only:

| Field | Why | What is not stored |
|---|---|---|
| Scanned registered domain | Which subjects are of interest | Full address, path, query, IP address |
| Outcome (ok, invalid, failed, rate limited) | Product health | Error text |
| Score range, duration | Quality and speed | Exact result |
| Country, device class, referring site name, language | Where use comes from | User-agent string, cookies |
| Bot score 0 to 3 | Separates human from automated traffic in reports | Raw headers |
| Daily visitor pseudonym | Counts distinct visitors within one day | Anything usable across days |

The pseudonym is a keyed hash of connection data with a day-specific key. It counts distinct visitors inside a single UTC day and cannot follow one person from one day to the next. Without the key it is simply left out.

## Controls

- **Purpose limitation.** Used only for aggregate statistics and abuse detection.
- **Retention.** Raw rows are deleted after 90 days by a scheduled job that runs with the existing daily routine.
- **Access.** The table is closed to browser and signed-in roles; only the server role can write or read. A reporting view exposes human traffic only.
- **Notice before release.** The privacy notice is updated in the same change as the code. A notice that says 'not stored' while data is stored is a defect.
- **Production writes need a person.** The schema change is applied by the owner, not by an agent or tool.

## How it is checked

- Unit tests prove the event contains no address, no user-agent text and no query string, that the pseudonym differs between days, and that a malformed domain is dropped.
- A static test over all database migrations forbids destructive statements. It caught a real violation during development: the first design put the 90-day purge into the migration. The purge moved to application code, which is also easier to test.
- The scan endpoint is exercised end to end with the store unreachable, to prove that measurement can never slow down or break the product.

## Limits

- Country and device class are approximate; bot detection is a heuristic used only to separate reports.
- The first reports will be small. Real use shows in completed actions, not in visits.

Status: implemented and tested; applying it to production waits for owner approval of the schema change and the updated privacy notice.

See [quality-engineering.md](quality-engineering.md) for the test levels and [architecture.md](architecture.md) for where this sits in the layers.
