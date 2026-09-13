  $ . "$TESTDIR/helper.sh"

Without -f or -n, rcgc asks once before it removes the batch. The prompt is
written without a trailing newline, so the answer appears on the same line

  $ touch .dotfiles/testrc
  > rcup >/dev/null
  > rm .dotfiles/testrc

An answer of n keeps the links

  $ echo n | rcgc
  stale: */.testrc -> */.dotfiles/testrc (glob)
  remove 1 stale link(s)? [yN]  (no-eol)

  $ assert "the link should survive a refusal" -h "$HOME/.testrc"

An answer of y removes them

  $ echo y | rcgc
  stale: */.testrc -> */.dotfiles/testrc (glob)
  remove 1 stale link(s)? [yN] removing: */.testrc -> */.dotfiles/testrc (glob)

  $ refute "the link should be gone" -h "$HOME/.testrc"

Any other answer keeps them

  $ touch .dotfiles/testrc
  > rcup >/dev/null
  > rm .dotfiles/testrc

  $ echo nope | rcgc
  stale: */.testrc -> */.dotfiles/testrc (glob)
  remove 1 stale link(s)? [yN]  (no-eol)

  $ assert "the link should survive a refusal" -h "$HOME/.testrc"

An answer of Y removes them, as does any longer answer beginning with y

  $ echo Y | rcgc
  stale: */.testrc -> */.dotfiles/testrc (glob)
  remove 1 stale link(s)? [yN] removing: */.testrc -> */.dotfiles/testrc (glob)

  $ refute "the link should be gone" -h "$HOME/.testrc"

  $ touch .dotfiles/testrc
  > rcup >/dev/null
  > rm .dotfiles/testrc

  $ echo yes | rcgc
  stale: */.testrc -> */.dotfiles/testrc (glob)
  remove 1 stale link(s)? [yN] removing: */.testrc -> */.dotfiles/testrc (glob)

  $ refute "the link should be gone" -h "$HOME/.testrc"

  $ rcgc
  clean
