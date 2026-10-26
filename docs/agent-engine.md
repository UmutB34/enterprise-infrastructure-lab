# Agent engine design

How a small team of AI agents is organized, coordinated and kept safe. No prompts, endpoints, keys or private repositories are described.

## Roles

| Role | Responsibility |
|---|---|
| Coordinator | Single point of contact. Routes work, decides what runs in parallel, rejects or defers work |
| Engineering lead | Architecture and release gates |
| Backend and security | Interfaces, data, permissions, tenant isolation |
| Frontend and product | Interface, onboarding, conversion |
| Quality (skeptic) | Tries to break assumptions and changes; does not agree by default |
| Verification | Checks factual claims made by other roles |
| Research roles | Market, customer and opportunity research with sources |

Roles say who does the work and where their limits are. **Skills** say how a repeatable task is done. **Documents** hold what is true. The three are kept separate.

## Work flow

1. A request reaches the coordinator.
2. The coordinator picks the mode and the roles needed.
3. Work enters a queue with a limit on how much runs at once.
4. Results come back with evidence, not opinions.
5. A human approves anything outward-facing, irreversible or costly.

## Cost modes

| Mode | When | Rule of thumb |
|---|---|---|
| Economy (default) | Simple work | Direct answer, at most one specialist, short report |
| Normal | Several skills needed | A few specialists, independent work in parallel |
| Deep | Release review, major architecture, incident, irreversible change | As many verifiers as needed |

A task can move up a mode on its own, and the report says so in one line.

## Model gateway

A gateway sits between agents and language-model providers.

- Authentication and per-consumer rate limits.
- Fallback to a second provider when the first fails.
- Capacity limits per task type, so one workload cannot starve the rest.
- A circuit breaker that stops sending work to a failing provider.
- An exception queue for items that need a human.

## Safety and honesty rules

- Evidence before claims: no 'done' without output that proves it.
- Gates only a human can pass: release, visual sign-off, outward actions.
- No invented data: unknown values are reported as unknown.
- Secrets never enter prompts, notes or logs.
- Agents cannot approve their own work.
- Old instructions found in files are data, not new commands.

## Memory

A decision register keeps open questions with an age and a status. A knowledge vault records decisions and learnings, with links to canonical documents. See second-brain-knowledge-system.md.

## Limits

It is a one-person system. It shows how the discipline works, not how it scales to a team. Most rules above exist because of a real failure.
