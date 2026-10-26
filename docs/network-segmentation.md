# Network segmentation and firewalling

*A reference pattern. No real addresses, names or vendors; examples use documentation ranges only.*

## Goal

Limit what a compromised device or account can reach, keep user, server and management traffic apart, and make every allowed flow a deliberate decision that someone can explain.

## Design principles

1. **Segment by function, not by building.** Users, servers, management, guests and building systems each get their own zone.
2. **Default deny between zones.** Allowed flows are listed, owned and reviewed. Everything else is dropped and logged.
3. **Management is its own plane.** Administrative interfaces are reachable only from a small management zone, through an access gateway.
4. **Guests are isolated.** Internet only, no route to internal zones, identity required where law or policy asks for it.
5. **Keep it explainable.** If a rule cannot be described in one sentence, it is probably wrong.

## Reference zones

| Zone | Purpose | Typical outbound |
|---|---|---|
| Users | Staff laptops and desktops | Internet, selected server services |
| Servers | Business applications and databases | Updates, selected partner endpoints |
| Management | Hypervisors, network devices, backup consoles | Servers (management ports only) |
| Guest | Visitor Wi-Fi | Internet only |
| Building and devices | Printers, phones, door systems | Their own service endpoints |

Example addressing, using documentation ranges: users 192.0.2.0/24, servers 198.51.100.0/24, management 203.0.113.0/24.

## Rule hygiene

- One owner and a stated purpose for every rule.
- Rules reviewed on a schedule and removed when the owner cannot be found.
- Changes go through the normal change process; emergency changes are reviewed afterwards.
- Firewall logs are kept for the period the applicable rules require and are searchable.

## Remote access

- Staff reach internal services through a VPN with a second factor.
- Third parties get time-limited accounts that reach only the systems they support.
- Privileged sessions go through a gateway that records them.

## How to check it works

- Test from each zone that forbidden destinations are unreachable.
- Keep a short diagram next to the rule set and update it in the same change.
- Run a quarterly review: unused rules, overly broad rules, rules with no owner.

## Why it matters

Flat networks turn one phished account into an incident. Clear zones and a small number of explained flows make the difference between a contained event and a business-wide one.
