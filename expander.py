#!/usr/bin/env python3

import re
import argparse
from logging import Logger, basicConfig, getLogger
import os
from os import getenv, environ, path
from pathlib import Path
from typing import List
import subprocess
import tempfile


logger = getLogger(__name__)  # type: Logger

ATCODER_INCLUDE = re.compile(r'\s*(include|import)\s*([a-zA-Z0-9_,./\s"]*)\s*')

WHEN_STATEMENT = re.compile(r'^\s*when\s+.*:')
ATCODER_DIR = re.compile('^(?:cplib)\/')
INDENT_WIDTH = 2
compress_type = "xz"  # "xz" or "bzip2" or "gzip"

if compress_type == "xz":
    decompress = "xzcat"
elif compress_type == "bzip2":
    decompress = "bzcat"
elif compress_type == "gzip":
    decompress = "zcat"


outputPrefix = """"""


def indent_level(line: str):
    """
    Indent level detector
    """
    for i, _c in enumerate(line):
        if _c != ' ':
            return i
    return len(line)


def strip_as(line: str) -> str:
    """
    import's as handling
    """
    pos = line.find(' as ')
    if pos != -1:
        line = line[:pos]
    return line


def main():
    """
    Main entry point
    """
    global ATCODER_DIR
    td = tempfile.TemporaryDirectory()
    lib_tmp = Path(td.name)
    basicConfig(
        format="%(asctime)s [%(levelname)s] %(message)s",
        datefmt="%H:%M:%S",
        level=getenv('LOG_LEVEL', 'INFO'),
    )
    parser = argparse.ArgumentParser(description='Expander')
    parser.add_argument('source', help='Source File')
    parser.add_argument('-c', '--console', action='store_true', help='Print to console')
    parser.add_argument('-s', '--single-line', action='store_true', help='Single line import')
    parser.add_argument('-cmp', '--compress', action='store_true', help='Compress import')
    parser.add_argument('--lib', nargs='*', help='Path to library')
    parser.add_argument('-d', '--directory', action='store_true', help='Submit by directory')
    parser.add_argument('-b', '--raw', action='store_true', help='Submit raw data')
    parser.add_argument('--expand-atcoder', action='store_true', help='Expand Nim-ACL')
    opts = parser.parse_args()

    if opts.expand_atcoder:
        ATCODER_DIR = re.compile('^(?:cplib|atcoder)\/')
    if opts.lib:
        lib_path = [Path(__file__).parent.resolve()]
        for d in opts.lib:
            lib_path.append(Path(d) / "src")
    elif 'NIM_INCLUDE_PATH' in environ:
        lib_path.append(Path(environ['NIM_INCLUDE_PATH']) / "src")
    else:
        lib_path = [Path(__file__).parent.resolve()]

    def read_source(f: str, prefix: str, defined: set, lib_path: List[str], is_main=True, load_type=None) -> List[str]:
        """
        Read source file handling import/include
        """
        if f in defined:
            logger.info('already included {:s}, skip'.format(f))
            return []

        defined.add(f)

        if is_main:
            source = open(f, encoding="utf8", errors='ignore').read()
        else:
            for d in lib_path:
                if not path.exists(str(d / f)):
                    continue
                source = open(str(d / f), encoding="utf8", errors='ignore').read()
                break
            else:
                raise Exception("Can't find {:s}".format(f))
            logger.info('{:s} {:s}'.format(load_type, f))

        if not is_main and opts.directory:
            copy_source_path = lib_tmp / f
            os.makedirs(copy_source_path.parents[0], exist_ok=True)
            for d in lib_path:
                if not path.exists(str(d / f)):
                    continue
                r = open(Path(lib_path / f)).read()
                break
            else:
                raise Exception("Can't find {:s}".format(f))
            open(copy_source_path, "w").write(r)

        result = []
        i = 0
        source = source.splitlines()
        while i < len(source):
            line = source[i]
            if WHEN_STATEMENT.match(line):
                result.append(line)
                i += 1
            elif ATCODER_INCLUDE.match(line):
                result.append(line)
                i += 1
            else:
                result.append(line)
                i += 1

        return result

    def do_expansion():
        defined = set()
        expanded = read_source(opts.source, "", defined, lib_path, is_main=True)
        for line in expanded:
            if opts.single_line:
                print(line.strip())
            elif opts.console:
                print(line.strip())
            elif opts.raw:
                print(line)
            else:
                print(line)
    
    do_expansion()
    logger.info('expansion complete')


if __name__ == '__main__':
    main()