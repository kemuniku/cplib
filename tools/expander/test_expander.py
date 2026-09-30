import os
from pathlib import Path
import subprocess
import tempfile
import unittest


NIM = os.environ.get("NIM", "nim")
EXPANDER = Path(__file__).with_name("expander.nim")


class ExpanderKeywordTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.build = tempfile.TemporaryDirectory()
        cls.expander = Path(cls.build.name) / "expander"
        cls.run_command([NIM, "cpp", "--hints:off", "-d:release",
                         f"--nimcache:{cls.build.name}/cache",
                         f"--out:{cls.expander}", str(EXPANDER)])

    @classmethod
    def tearDownClass(cls):
        cls.build.cleanup()

    @staticmethod
    def run_command(command, cwd=None):
        result = subprocess.run(command, cwd=cwd, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if result.returncode:
            raise AssertionError(f"{command!r}\n{result.stdout}")
        return result.stdout

    def check_source(self, source, files=None, expanded_fragments=(),
                     compile_original=True):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name, content in (files or {}).items():
                (root / name).write_text(content, encoding="utf-8")
            (root / "main.nim").write_text(source, encoding="utf-8")
            if compile_original:
                self.run_command([NIM, "cpp", "-r", "--hints:off",
                                  "--nimcache:cache_main", "main.nim"], root)
            for options in ([], ["--single-line"], ["--compress"],
                            ["--compress", "--original-source"]):
                if not compile_original and "--original-source" in options:
                    continue
                with self.subTest(options=options):
                    self.run_command([str(self.expander), "--quiet", *options,
                                      "main.nim"], root)
                    if not options:
                        output = (root / "combined.nim").read_text(encoding="utf-8")
                        for fragment in expanded_fragments:
                            self.assertIn(fragment, output)
                    self.run_command([NIM, "cpp", "-r", "--hints:off",
                                      "--nimcache:cache_combined", "--path:.", "combined.nim"], root)

    def test_keyword_prefixed_identifiers(self):
        source = """var importance = 0
var include_count = 0
var import2 = 0
var includeé = 0
proc imported() = inc importance
proc included() = inc include_count
importance = 1
include_count = 1
import2 = 2
includeé = 3
imported()
included()
block:
  imported()
  included()
doAssert importance == 3
doAssert include_count == 3
doAssert import2 == 2
doAssert includeé == 3
"""
        self.check_source(source, expanded_fragments=[source])

    def test_real_imports_and_includes(self):
        files = {"first.nim": "const firstValue* = 1\n",
                 "second.nim": "const secondValue* = 2\n",
                 "third.nim": "const thirdValue* = 3\n",
                 "fourth.nim": "const fourthValue = 4\n",
                 "fifth.nim": "const fifthValue = 5\n"}
        source = "import first, second\nimport  third\ninclude fourth\nblock:\n  include  fifth\n  doAssert fifthValue == 5\ndoAssert firstValue + secondValue + thirdValue + fourthValue == 10\n"
        self.check_source(source, files,
                          ["const firstValue* = 1", "const secondValue* = 2",
                           "const thirdValue* = 3", "const fourthValue = 4",
                           "  const fifthValue = 5"])

    def test_comment_boundary_and_quoted_module_names(self):
        self.check_source('import#[comment]# "strutils"\ninclude "quoted"\ndoAssert "foo".toUpperAscii == "FOO"\ndoAssert quoted == 7\n',
                          {"quoted.nim": "const quoted = 7\n"},
                          ['import #[comment]# "strutils"', 'include "quoted"'])

    def test_tab_separator_normalization(self):
        # Nim自体はタブを拒否するが、従来のexpanderの正規化を維持する。
        self.check_source("import\tfirst\ninclude\tsecond\ndoAssert firstValue + secondValue == 3\n",
                          {"first.nim": "const firstValue* = 1\n",
                           "second.nim": "const secondValue = 2\n"},
                          ["const firstValue* = 1", "const secondValue = 2"],
                          compile_original=False)


if __name__ == "__main__":
    unittest.main()
