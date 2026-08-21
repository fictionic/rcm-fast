  $ . "$TESTDIR/helper.sh"

Renaming a dotfile in the repo leaves the old link behind, because rcup only
ever computes forward from what the repo now contains

  $ touch .dotfiles/oldrc
  > rcup >/dev/null

  $ mv .dotfiles/oldrc .dotfiles/newrc
  > rcup >/dev/null

  $ assert_linked "$HOME/.newrc" "$HOME/.dotfiles/newrc"
  $ assert "the old link is still there" -h "$HOME/.oldrc"

rcdn is no help either: it removes what the repo describes, and the repo no
longer describes the old name

  $ rcdn >/dev/null

  $ assert "rcdn leaves the orphan" -h "$HOME/.oldrc"

  $ rcup >/dev/null

rcgc is what collects it, and leaves the live link alone

  $ rcgc -n
  stale: */.oldrc -> */.dotfiles/oldrc (glob)
  1 stale link(s)

  $ rcgc -f
  removing: */.oldrc -> */.dotfiles/oldrc (glob)

  $ refute "the old link should be gone" -h "$HOME/.oldrc"
  $ assert_linked "$HOME/.newrc" "$HOME/.dotfiles/newrc"

  $ rcgc
  clean
