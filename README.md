rcm-fast
========

> A fork of [thoughtbot/rcm](https://github.com/thoughtbot/rcm) with improved
> performance, bug fixes, and additional features.

This is a management suite for dotfiles. **See the tutorial in `rcm(7)` to get
started quickly.**

It assumes that you have a separate dotfiles directory, or are
interested in creating one.

The programs provided are `rcup(1)`, `mkrc(1)`, `rcdn(1)`, and `lsrc(1)`. They
are explained in the tutorial and configured using `rcrc(5)`.

Fast?
-----

This fork offers two advantages over upstream RCM:

1. As the name suggests, it is faster. RCM is rather slow because it forks
   several subprocesses per dotfile to compute their destination. `rcm-fast`
   uses shell builtins instead, which, on a 200-entry dotfiles directory,
   results in about a 3x speedup over upstream. (See `maint/benchmark`.)
2. It fixes some relatively minor bugs.

Behavior parity with upstream can be verified via the `maint/difftest` script,
which checks `lsrc` output against your actual dotfiles.

Because RCM has had no behavioral code change since 2022 (and its open pull
requests go unreviewed), this is maintained as its own project rather than as a
patch series waiting to be pulled in.

Installation
------------

Arch Linux (AUR):

    https://aur.archlinux.org/packages/rcm-fast

MacOS (Homebrew):

    brew install fictionic/tap/rcm-fast

From a release tarball:

    curl -LO https://github.com/fictionic/rcm-fast/releases/download/$VERSION/rcm-fast-$VERSION.tar.gz
    tar -xf rcm-fast-$VERSION.tar.gz
    cd rcm-fast-$VERSION
    ./configure
    make
    sudo make install

From source -- needs autoconf, automake and pystache:

    git clone https://github.com/fictionic/rcm-fast
    cd rcm-fast
    ./autogen.sh
    ./configure
    make
    sudo make install

Of course, make sure to remove an installation of upstream RCM first.

Programs
--------

* `rcup(1)` is the main program. It is used to install and update
  dotfiles, with support for tags, host-specific files, and multiple source
  directories.
* `rcdn(1)` is the opposite of `rcup(1)`.
* `mkrc(1)` is for introducing a dotfile into your dotfiles directory,
  with support for tags and multiple source directories.
* `lsrc(1)` shows you all your dotfiles and where they would be
  symlinked to. It is used by `rcup(1)` but is provided for your own
  use, too.

Support
-------

This is a personal fork, maintained for my own use. I am not soliciting
contributions and make no promises about response times. See `DEVELOPERS.md`
to build it yourself.

License
-------

Copyright 2013 Mike Burns. BSD license.
Copyright 2014 thoughtbot. BSD license.
Copyright 2026 Dylan Forbes. BSD license.
