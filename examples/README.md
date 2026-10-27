# Examples

Small, runnable or checkable pieces that go with the documents. Everything uses documentation-range addresses and placeholder keys.

| Example | What it shows | Status |
|---|---|---|
| `backup/restore-test.sh` | A backup is real only after a restore and a checksum comparison | **Runs anywhere with bash and tar**; `make test` |
| `docs-sync/pull-docs.sh` | One writable documentation copy; workloads pull a read-only copy on a schedule | Shell syntax checked (`bash -n`); needs your own server to run |
| `access/authorized_keys.forced-command.example` | A pull key that can only read one repository: no shell, no push | Example line, replace the key and path |
| `ansible/baseline.yml` | Key-only SSH, automatic security updates, default-deny firewall, idempotent | YAML parsed and checked; run with `--check --diff` first on your host |
| `terraform/main.tf` | One role-separated container on Proxmox, declared as code | **Not applied or validated here**; run `terraform validate` before use |

Run what can run:

```bash
make test        # restore test (needs bash, tar, sha256sum)
```

Related documents: [backup-recovery](../docs/backup-recovery.md), [documentation-sync](../docs/documentation-sync.md), [access-model](../docs/access-model.md).
