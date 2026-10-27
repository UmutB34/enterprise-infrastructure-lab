# Topology and layers

How the lab fits together, drawn from the machine up to the screen I use. Addresses, host names, ports and credentials are left out on purpose. Status was checked on the hypervisor on the day of writing; things that are not built yet are marked **planned**.

## 1. Platform topology

```mermaid
%%{init: {"theme":"base","flowchart":{"curve":"basis","nodeSpacing":26,"rankSpacing":44},"themeVariables":{"lineColor":"#5B7BA6","primaryColor":"#EEF3FA","primaryBorderColor":"#5B7BA6","primaryTextColor":"#1D3557","clusterBkg":"#F7F9FC","clusterBorder":"#C5D1E3"}}}%%
flowchart TB
  classDef use  fill:#E8F3EC,stroke:#3D8B5A,color:#17432A,stroke-width:1.5px
  classDef idle fill:#F6F3E4,stroke:#A09034,color:#4A4310,stroke-width:1.5px,stroke-dasharray:4 3
  classDef plan fill:#FBECEC,stroke:#B24A4A,color:#5C1E1E,stroke-width:1.5px,stroke-dasharray:6 4
  classDef ext  fill:#EAF0F8,stroke:#5B7BA6,color:#1D3557,stroke-width:1.5px
  classDef core fill:#1D3557,stroke:#1D3557,color:#FFFFFF,stroke-width:1.5px

  OWNER["Owner devices<br/>phone · desktop"]
  MESH["Private mesh VPN<br/>the only way in from outside"]

  subgraph HOST["Host: mini PC · 12-core CPU · 64 GB RAM · NVMe"]
    PVE["Proxmox VE hypervisor<br/>thin-provisioned local storage"]
    subgraph CT["Containers · one role each"]
      DEV["Engineering workspace<br/>owner app · coding agent · tests"]
      BOARD["Task platform<br/>roles · evidence gate"]
      AGENT["Agent gateway<br/>runtime · model gateway"]
      AUTO["Automation pilot<br/>pilot data only"]
      OBS["Observability PoC<br/>synthetic data only"]
    end
    subgraph VM["Virtual machines"]
      WIN["Windows Server 2025<br/>directory · DNS · group policy"]
      SEC["Security monitoring VM<br/>detection practice"]
    end
    FW["Firewall and VLAN segmentation<br/>PLANNED, not built"]
  end

  BKP["Scheduled backups<br/>automated restore test"]
  GITX["Hosted git copy<br/>docs and code"]

  OWNER -->|"private tunnel"| MESH
  MESH --> DEV
  DEV -->|"opens task"| BOARD
  BOARD -->|"assigns role and brief"| AGENT
  PVE --- CT
  PVE --- VM
  PVE -->|"daily"| BKP
  DEV -->|"push"| GITX
  FW -.->|"will front"| PVE

  class PVE core
  class OWNER,MESH,GITX,BKP ext
  class DEV,BOARD,AGENT,AUTO,WIN use
  class OBS,SEC idle
  class FW plan
```

Legend: green = in use · dashed yellow = built, powered off when idle · dashed red = planned, not built · dark = hypervisor.

Why this shape: a hypervisor on one low-power machine gives me containers for quick, cheap Linux workloads and a real virtual machine where I need a separate kernel (Windows Server). Each container has one job, so a fault in one does not share files or processes with another.

## 2. Layer model

```mermaid
%%{init: {"theme":"base","flowchart":{"curve":"basis","nodeSpacing":30,"rankSpacing":30},"themeVariables":{"lineColor":"#5B7BA6","primaryColor":"#EEF3FA","primaryBorderColor":"#5B7BA6","primaryTextColor":"#1D3557"}}}%%
flowchart TB
  classDef gov  fill:#FFF4E0,stroke:#C98A1B,color:#5A3B00,stroke-width:1.5px
  classDef own  fill:#EAF0F8,stroke:#5B7BA6,color:#1D3557,stroke-width:1.5px
  classDef eng  fill:#E8F3EC,stroke:#3D8B5A,color:#17432A,stroke-width:1.5px
  classDef prod fill:#F1ECFA,stroke:#7A5BB0,color:#2E1D57,stroke-width:1.5px
  classDef qa   fill:#FBECEC,stroke:#B24A4A,color:#5C1E1E,stroke-width:1.5px
  classDef know fill:#E6F4F7,stroke:#2F8FA3,color:#0F3F4A,stroke-width:1.5px
  classDef plat fill:#EDEDED,stroke:#6B6B6B,color:#222222,stroke-width:1.5px

  GOV["<b>GOVERNANCE</b><br/>decision register with ages<br/>approval gates only a human passes<br/>evidence before claims"]
  OWN["<b>OWNER SURFACE</b><br/>one management screen<br/>progress · decisions waiting · alerts"]
  ENG["<b>WORK ENGINE</b><br/>coordinator and specialist roles<br/>work queue · engine chain"]
  PRD["<b>PRODUCTS</b><br/>security monitoring · automation workflows<br/>privacy-minimised measurement"]
  QA["<b>QUALITY</b><br/>unit · integration · negative · end-to-end<br/>visual · accessibility · human-signed release"]
  PLT["<b>PLATFORM</b><br/>hypervisor · containers · VMs · private access<br/>backup with restore test · documentation sync"]
  KNW["<b>KNOWLEDGE</b><br/>notes vault · hybrid search<br/>canonical documents"]

  GOV -.->|"constrains every layer"| OWN
  OWN --> ENG --> PRD --> QA --> PLT
  ENG <-->|"read and write"| KNW

  class GOV gov
  class OWN own
  class ENG eng
  class PRD prod
  class QA qa
  class PLT plat
  class KNW know
```

| Layer | What lives here | Notes |
|---|---|---|
| Owner surface | **Brain**: one installable web app (phone and desktop) for progress, decisions, approvals | Opened over the private mesh VPN; the task platform behind it is not what I work in |
| Application layer | Brain, the products (a security monitoring product, workflow automations, a desktop app), the coding agent | Built and tested in the engineering workspace |
| Service layer | Task platform, agent gateway (**Hermes Agent**), model gateway, automation engine | Roles, an evidence gate and a chain of engines; the engine that builds a task never audits it |
| Knowledge layer | **Obsidian** notes vault (decisions, learnings, project context), hybrid keyword and meaning search, decision register | Synchronized between the workstation and the containers with versions kept; no secrets stored |
| Identity and directory | Windows Server VM: directory, DNS, group policy | Practice environment for server and access administration |
| Platform layer | Proxmox VE, thin storage, backups, documentation sync | One writable copy of the documentation; containers pull read-only copies on a schedule |
| Hardware | The host machine | Chosen for cost, noise and power draw |

## 3. What happens when I give a task

```mermaid
sequenceDiagram
  participant O as Owner (Brain)
  participant T as Task platform
  participant A as Agent gateway (Hermes)
  participant E as Engine chain
  participant K as Vault and tests
  O->>T: open task, set the goal
  T->>A: assign role and brief
  A->>E: work with the first available engine
  E-->>A: result
  A->>K: run tests, store notes
  K-->>T: evidence (outputs, results)
  T-->>O: ready for approval, with the evidence attached
  O->>T: approve or send back
```

If an engine reaches its limit, the next one in the chain takes over. A task cannot be closed without evidence, and only I can approve the gates that matter (release, outward messages).

## 4. Status of the parts

| Part | Status |
|---|---|
| Hypervisor, containers, backups, documentation sync | In use |
| Brain (owner surface) | In use |
| Agent gateway and task platform | In use |
| Automation pilot | In use, on pilot data |
| Windows Server VM | In use as a practice environment |
| Observability proof of concept | Built, powered off when idle |
| Security monitoring VM | Built, powered off when idle |
| Firewall and VLAN segmentation | **Planned**, not built |

## 5. Data flows

Three flows that make the platform trustworthy. Each is one direction, narrow and checkable.

### Documentation: one writable copy

```mermaid
%%{init: {"theme":"base","flowchart":{"curve":"basis","nodeSpacing":26,"rankSpacing":40},"themeVariables":{"lineColor":"#5B7BA6","primaryColor":"#EEF3FA","primaryBorderColor":"#5B7BA6","primaryTextColor":"#1D3557"}}}%%
flowchart LR
  classDef src  fill:#1D3557,stroke:#1D3557,color:#FFFFFF,stroke-width:1.5px
  classDef cons fill:#EAF0F8,stroke:#5B7BA6,color:#1D3557,stroke-width:1.5px
  classDef sink fill:#E8F3EC,stroke:#3D8B5A,color:#17432A,stroke-width:1.5px
  classDef ctl  fill:#FFF4E0,stroke:#C98A1B,color:#5A3B00,stroke-width:1.5px

  SRC["Source repository<br/>the only writable copy"]
  C1["Container copy A<br/>read-only"]
  C2["Container copy B<br/>read-only"]
  SRC -->|"scheduled pull<br/>restricted key"| C1
  SRC -->|"scheduled pull<br/>restricted key"| C2

  class SRC src
  class C1,C2 cons
```

### Product measurement: minimal events, short retention

```mermaid
%%{init: {"theme":"base","flowchart":{"curve":"basis","nodeSpacing":26,"rankSpacing":40},"themeVariables":{"lineColor":"#5B7BA6","primaryColor":"#EEF3FA","primaryBorderColor":"#5B7BA6","primaryTextColor":"#1D3557"}}}%%
flowchart LR
  classDef cons fill:#EAF0F8,stroke:#5B7BA6,color:#1D3557,stroke-width:1.5px
  classDef sink fill:#E8F3EC,stroke:#3D8B5A,color:#17432A,stroke-width:1.5px
  classDef ctl  fill:#FFF4E0,stroke:#C98A1B,color:#5A3B00,stroke-width:1.5px

  ACT["Completed<br/>public action"]
  EVT["Minimal event<br/>no address · no user-agent · no cookie"]
  STORE["Server-only table<br/>no browser access"]
  REP["Human-traffic report"]
  PURGE["Daily purge<br/>rows older than 90 days"]

  ACT -->|"after the response"| EVT --> STORE
  STORE --> REP
  STORE --> PURGE

  class ACT cons
  class EVT,PURGE ctl
  class STORE,REP sink
```

Backups follow the same idea: a daily off-host copy with an automated restore test. See backup-recovery.md and measurement-and-privacy.md.

## 6. Why a lab like this is useful

It is a small, honest copy of the questions a production team answers: who can reach what, how a change is approved, how a failure is detected and recovered, and what proves a task is really done. The lab shows the method; the numbers at work are bigger, the questions are the same.

See [end-to-end-architecture.md](end-to-end-architecture.md) for the walk-through in words, [access-model.md](access-model.md) for access, and [backup-recovery.md](backup-recovery.md) for recovery.
