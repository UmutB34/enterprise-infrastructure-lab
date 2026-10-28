"""Fail if a Markdown file contains an IPv4 address outside the RFC 5737 documentation ranges
or an e-mail address. A first-pass guard, not a substitute for human review (see REDACTION.md).
Usage: python scripts/check_redaction.py [root]
"""
import ipaddress
import re
import sys
from pathlib import Path

DOC = [ipaddress.ip_network(n) for n in ("192.0.2.0/24", "198.51.100.0/24", "203.0.113.0/24")]
IP = re.compile(r"\b(\d{1,3}(?:\.\d{1,3}){3})\b")
MAIL = re.compile(r"[\w.+-]+@[\w-]+\.[\w.]+")


def scan(text):
    problems = []
    for m in IP.finditer(text):
        try:
            ip = ipaddress.ip_address(m.group(1))
        except ValueError:
            continue
        if not any(ip in n for n in DOC):
            problems.append("ip " + m.group(1))
    for m in MAIL.finditer(text):
        problems.append("email " + m.group(0))
    return problems


def main(root="."):
    bad = 0
    for p in Path(root).rglob("*.md"):
        for pr in scan(p.read_text(encoding="utf-8", errors="replace")):
            print(f"{p}: {pr}")
            bad += 1
    print("problems:", bad)
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else "."))
