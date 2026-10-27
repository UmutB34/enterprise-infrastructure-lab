# Quality engineering

How changes are proven before anyone calls them done. The same approach applies to a product, an automation workflow or an infrastructure change.

## Levels of checking

| Level | What it proves | Examples |
|---|---|---|
| Unit | A rule or calculation behaves as specified | Scoring rules, input parsing, license checks |
| Integration | Components work together with real data stores | Database access, API contracts, billing events |
| Negative tests | The system refuses what it should refuse | Tenant isolation with a deliberately broken policy, unsafe addresses, malformed input |
| End-to-end | A user can finish a real journey | Sign up, run a scan, view a report, change plan |
| Visual | The interface still looks right | Screenshots compared across desktop and mobile, light and dark, two languages |
| Accessibility and links | The interface is usable and nothing is dead | Automated accessibility checks, link and button audit |

## Rules that keep the suite honest

1. **Never overwrite an existing test.** Read it, then extend it or add a clearly named companion file.
2. **Test counts do not drop** without a written reason.
3. **Tests must be able to fail.** A new test is first shown failing against the broken behaviour.
4. **Dated results are labelled with their date.** An old pass is not today's pass.
5. **Security checks are deterministic.** Scores and findings come from rules, never from a language model's guess.

## Static policy checks

Some rules are checked by reading the code, not by running it. A test over all database migrations forbids destructive statements, and another keeps secret names out of browser-visible settings. These tests catch design mistakes early: during one change the first draft put a data-retention purge inside a migration, the policy test refused it, and the purge moved to application code.

## Feature audit

Every visible control is classed as active, partial or coming soon. A missing capability is shown as disabled, never as a plausible placeholder. The audit is repeated after each larger change and the status document is corrected to match.

## Debugging method

Root cause first: reproduce, isolate, form one hypothesis, change one thing, verify with command output. Fixes without a reproduction are guesses.

## Release gate

Before a release candidate is declared: build, full automated tests, browser checks on desktop and mobile in both languages and themes, dependency and secret scans, and a review of what changed. The release status is reported as it is, including what was not tested.

- Visual and release approvals can only be given by a human; a tool or agent never self-approves.
- A skeptical reviewer role tries to break the change and challenge assumptions before sign-off.
- A separate verification role checks factual claims in reports.

## Evidence rule

A claim of 'fixed', 'passing' or 'done' is accompanied by the command output or artifact that shows it. A claim without evidence is treated as a guess.

## Measures

- Tests by level and their trend.
- Escaped defects found after release and their root causes.
- Time from change to verified release.
- Open items from the feature audit.
