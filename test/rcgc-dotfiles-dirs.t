  $ . "$TESTDIR/helper.sh"

DOTFILES_DIRS may name several repos. Entries are expanded and made absolute
the way rcm does it, so a literal ~ and a relative path both work.

  $ mkdir .second-dotfiles
  > touch .dotfiles/testrc .second-dotfiles/secondrc
  > echo 'DOTFILES_DIRS="~/.dotfiles .second-dotfiles"' > "$RCRC"

  $ rcup >/dev/null

  $ assert_linked "$HOME/.testrc" "$HOME/.dotfiles/testrc"
  $ assert_linked "$HOME/.secondrc" "$HOME/.second-dotfiles/secondrc"

  $ rm .dotfiles/testrc .second-dotfiles/secondrc

Both repos are ours

  $ rcgc -n
  stale: */.secondrc -> */.second-dotfiles/secondrc (glob)
  stale: */.testrc -> */.dotfiles/testrc (glob)
  2 stale link(s)

-d collects for the given repo instead of the configured ones

  $ rcgc -n -d "$HOME/.second-dotfiles"
  stale: */.secondrc -> */.second-dotfiles/secondrc (glob)
  1 stale link(s)

  $ rcgc -n -d "$HOME/.dotfiles"
  stale: */.testrc -> */.dotfiles/testrc (glob)
  1 stale link(s)

-d can be repeated

  $ rcgc -n -d "$HOME/.dotfiles" -d "$HOME/.second-dotfiles"
  stale: */.secondrc -> */.second-dotfiles/secondrc (glob)
  stale: */.testrc -> */.dotfiles/testrc (glob)
  2 stale link(s)

A repo that is not named is not ours

  $ rcgc -d "$HOME/.second-dotfiles" -f
  removing: */.secondrc -> */.second-dotfiles/secondrc (glob)

  $ assert "the other repo's orphan is untouched" -h "$HOME/.testrc"
