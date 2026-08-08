# ABIOSDSK Version 0.90 prerelease
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd

import copy
import json
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import pifjson  # noqa: E402


class PifJsonTest(unittest.TestCase):
    def load_config(self, number):
        path = HERE / f"DSTRS{number}.PIF.json"
        return json.loads(path.read_text(encoding="utf-8"))

    def test_stress_configs_are_lossless_and_self_consistent(self):
        for number in (1, 2):
            with self.subTest(number=number):
                document = self.load_config(number)
                encoded = pifjson.json_to_pif(document)
                decoded = pifjson.pif_to_json(encoded)

                self.assertTrue(decoded["base"]["checksum"]["valid"])
                self.assertEqual(
                    decoded["base"]["program"],
                    rf"C:\STRSSTST\DSTRS{number}.EXE",
                )
                self.assertEqual(
                    decoded["base"]["startup_directory"], r"C:\STRSSTST"
                )
                self.assertEqual(pifjson.json_to_pif(decoded), encoded)

    def test_known_edits_preserve_unmodeled_bytes(self):
        document = copy.deepcopy(self.load_config(1))
        original = pifjson.json_to_pif(document)
        document["base"]["title"] = "Edited title"
        section = next(
            item for item in document["extensions"] if "windows_386" in item
        )
        section["windows_386"]["behavior"]["background"] = False

        edited = pifjson.json_to_pif(document)
        decoded = pifjson.pif_to_json(edited)
        decoded_section = next(
            item for item in decoded["extensions"] if "windows_386" in item
        )

        self.assertNotEqual(edited, original)
        self.assertEqual(decoded["base"]["title"], "Edited title")
        self.assertFalse(decoded_section["windows_386"]["behavior"]["background"])
        self.assertEqual(pifjson.json_to_pif(decoded), edited)


if __name__ == "__main__":
    unittest.main()
