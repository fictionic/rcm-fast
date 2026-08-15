Developers
==========

Setup
-----

1. Install dependencies:
   - cram, for the test suite: `pip install cram`
   - pystache, to build `man/rcm.7` from its mustache template:
     `pip install pystache`
   - hyperfine, only if you want to run `maint/benchmark`:
     `pacman -S hyperfine` or `brew install hyperfine`
2. Prepare the build system: `./autogen.sh`. (This depends on GNU autoconf
   and GNU automake.)
3. Configure the package: `./configure`.
4. Make sure the tests pass: `make check`.

Testing
-------

The test suite uses [cram][]. It is an integration suite, meaning the
programs are exercised from the outside and assertions are made only on
their output or effects.

The test suite requires Perl with the `Cwd` module. It expects to find Perl as
`perl` in `$PATH`.

All tests can be run like so:

    make check

Individual tests can be run like so:

    env TESTS=test/lsrc-dotfiles-dirs.t make -e check

If you intend to write a new test:

1. Add your test at `test/subcommand-something-meaningful.t`.
2. Add the relative name to the `TESTS` variable in `Makefile.am`.
3. Source `test/helper.sh` as the first line of your test.
4. When in doubt, use existing tests as a guide.

`maint/difftest` compares this tree's `lsrc` output against unmodified upstream
rcm, over your real dotfiles. `make check` cannot catch a divergence there,
since both trees satisfy the same cram expectations.

[cram]: https://bitheap.org/cram/

Making a release
----------------

1. Bump the version within the `AC_INIT` macro call in `configure.ac`.

2. Update the build system by running: `./autogen.sh`.

3. Build the trivial packages:

   This all depends on a `gh-pages` branch:

        git branch gh-pages origin/gh-pages

    First build the distribution:

        ./configure
        make distcheck

    On any system you can build the tarball and tag:

        ./maint/release build tarball rcm-*.tar.gz
        ./maint/release build tag rcm-*.tar.gz

    You need mdocml to tranform the manpages into HTML:

        ./maint/release build man_html rcm-*.tar.gz

    Once built, you can push it live:

        ./maint/release push tarball rcm-*.tar.gz
        ./maint/release push tag rcm-*.tar.gz
        ./maint/release push man_html rcm-*.tar.gz

    And once pushed, you should clean up

        ./maint/release clean tarball rcm-*.tar.gz
        ./maint/release clean tag rcm-*.tar.gz
        ./maint/release clean man_html rcm-*.tar.gz
