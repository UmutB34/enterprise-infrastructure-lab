# Backup and recovery

*A reference pattern. It describes how backup and recovery should be designed and proven, not any specific environment.*

## Goal

Be able to restore the systems the business cannot work without, within a time the business has agreed to, and be able to prove it.

## Start from the business, not the tool

For each system record two numbers with the business owner:

- **RTO** (recovery time objective): how long the business can be without it.
- **RPO** (recovery point objective): how much recent data it can afford to lose.

Group systems into tiers (for example critical, important, standard) and size the solution to the tier.

## Design principles

1. **3-2-1 as a minimum.** Three copies, two kinds of storage, one copy offsite or offline.
2. **Immutable or offline copy.** At least one copy cannot be changed or deleted by an ordinary administrator account, so ransomware cannot remove it.
3. **Separate credentials.** Backup consoles use their own accounts, not the everyday domain admin identity.
4. **Application-consistent backups** for databases and messaging, not just file-level copies.
5. **Documented order of restore.** Identity and network first, then data services, then applications.

## Proving it

A backup that was never restored is a hope, not a control.

| Check | Frequency | Evidence |
|---|---|---|
| File and mailbox restore | Monthly | Ticket with result |
| Single system restore | Quarterly | Restore log, time taken |
| Full recovery exercise (failover and return) | Yearly | Written report with times and follow-up actions |

Write the exercise report so a non-technical reader can see what was covered, what was confirmed, how long it took, and what will be improved next.

## Roles

- A named owner for each tier.
- A runbook per critical system, kept where it is still reachable during an outage.
- A contact list for suppliers and internal decision makers.

## Common mistakes to avoid

- Backups stored in the same failure domain as production.
- Monitoring that checks "job finished" instead of "restorable".
- A recovery plan that depends on a system which is itself down.
- Never testing the return path (failback).
