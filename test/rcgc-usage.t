  $ . "$TESTDIR/helper.sh"

-h should output usage information and exit 0

  $ rcgc -h
  Usage: rcgc [-afhnqVv] [-d DOT_DIR]
  see rcgc(1) and rcm(7) for more details

Unsupported options should output usage information and exit EX_USAGE

  $ rcgc --version
  Usage: rcgc [-afhnqVv] [-d DOT_DIR]
  see rcgc(1) and rcm(7) for more details
  [64]

  $ rcgc -Z
  Usage: rcgc [-afhnqVv] [-d DOT_DIR]
  see rcgc(1) and rcm(7) for more details
  [64]

An unknown option is rejected even alongside valid ones

  $ rcgc -f -Z
  Usage: rcgc [-afhnqVv] [-d DOT_DIR]
  see rcgc(1) and rcm(7) for more details
  [64]

rcgc takes no file arguments

  $ rcgc .testrc
  Usage: rcgc [-afhnqVv] [-d DOT_DIR]
  see rcgc(1) and rcm(7) for more details
  [64]

-V should show the version number

  $ rcgc -V | head -1
  rcgc (rcm) * (glob)
