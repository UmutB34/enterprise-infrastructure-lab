# End-to-end architecture: from hardware to services

A walk through the whole stack of a one-person engineering lab, from the metal up to the screen the owner uses. Addresses, host names, ports and credentials are deliberately left out.

## Map

    Owner surface        one management screen (installable web app) · phone and desktop
    Work engine          task platform · roles · evidence gate · engine chain
    Engines              subscription engines · free models · local fallback
    Knowledge            notes vault · hybrid search · decision register
    Products             security monitoring product · automation workflows · desktop app
    Quality              tests · browser checks · release gates
    Workloads            role-separated containers · one Windows server VM
    Platform             hypervisor · storage · backup · documentation sync
    Hardware             small-form-factor host, 12-core class CPU, 64 GB RAM, NVMe storage

## 1. Hardware

One low-power, always-on mini PC. It was chosen for cost, noise and power draw, and it is enough for a dozen light workloads. Capacity is tracked, so growth is a decision, not a surprise.

## 2. Platform

- A hypervisor hosts both containers and virtual machines.
- Linux services run in containers for low overhead and quick rebuilds; a virtual machine is used only where a separate kernel is needed (a Windows server for identity and directory practice).
- Storage is thin-provisioned on local NVMe, with scheduled backups kept off the host.
- Documentation has one writable source; every container pulls a read-only copy on a schedule.
- Files are synchronized between the workstation and the containers with a sync tool that keeps versions.

## 3. Workloads

| Role | What it does |
|---|---|
| Engineering workspace | Builds and tests the products; hosts the coding agent and a remote session reachable from a phone |
| Agent gateway | Hosts the agent runtime and the model gateway |
| Automation pilot | Runs workflow automations on synthetic or pilot data |
| Observability proof of concept | Evaluates telemetry tooling with synthetic data only |
| Windows server VM | Directory and server administration practice |

Roles are separated so that a fault or compromise in one does not share files or processes with another.

## 4. Products

- **Security monitoring product (Korantix).** Checks a domain's public e-mail and web security posture from public data only. Findings and scores come from deterministic rules. Tenants are separated with row-level security, proven by negative tests. Billing runs behind a provider-neutral layer.
- **Automation workflows.** A form-driven workflow that turns messy files into structured records, with explainable matching and human approval.
- **Desktop app.** A small Windows application with an animation and behaviour engine.

## 5. Quality

Unit, integration and negative tests; browser tests on desktop and mobile in both languages and themes; accessibility and link audits; a release gate that only a human can pass. See quality-engineering.md.

## 6. Knowledge

A notes vault of decisions, learnings and project context, with search that combines keywords and meaning, and a register of open decisions. No secrets are stored. See second-brain-knowledge-system.md.

## 7. Agent engines

Work is done by a chain of engines rather than a single one.

| Engine type | Use |
|---|---|
| Subscription engines | Coding and design work, to avoid per-call API cost |
| Free hosted models | Research, translation, drafting, routine tasks |
| Premium reasoning model | Planning, quality review and decision preparation only |
| Local small models | Last-resort fallback |

Rules: the engine that builds a task never audits it; a task cannot be marked done without evidence; when an engine hits its limit the next in the chain takes over and the first returns when its limit resets; work stuck for more than thirty minutes is handed over; critical decisions can be debated by two or three free models, with the summary and the points of disagreement shown to the owner; licence terms (for example copyleft) are flagged before any code is reused. See agent-engine.md.

## 8. Owner surface

One management screen shows progress, decisions waiting, status of the products and alerts. The owner works from it and does not need to open the task platform behind it.

## 9. Scheduled routines

Daily and weekly status reports and a nightly read-only intelligence sweep run on a schedule. Backups run daily with an automated restore test, and an independent copy is kept at a hosted git service.

## Principles that run through every layer

- One source of truth, linked rather than copied.
- Deterministic where it matters; models where judgement helps.
- Evidence before claims, and humans for gates.
- Least privilege for every key, account and agent.
- Cost modes: economy by default, deeper only when the risk justifies it.
