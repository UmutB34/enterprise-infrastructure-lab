import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "scripts"))
import check_redaction as c


class T(unittest.TestCase):
    def test_doc_range_ok(self):
        self.assertEqual(c.scan("host 192.0.2.10 and 203.0.113.5"), [])

    def test_private_ip_flagged(self):
        self.assertEqual(c.scan("server 10.1.2.3"), ["ip 10.1.2.3"])

    def test_email_flagged(self):
        self.assertEqual(len(c.scan("mail a@b.com")), 1)

    def test_not_an_ip(self):
        self.assertEqual(c.scan("value 999.1.1.1"), [])


if __name__ == "__main__":
    unittest.main()
