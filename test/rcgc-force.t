  $ . "$TESTDIR/helper.sh"

rcup descends into directories, so a nested config becomes a real directory in
$HOME holding symlinks

  $ mkdir -p .dotfiles/config/solo .dotfiles/config/shared
  > touch .dotfiles/config/solo/only
  > touch .dotfiles/config/shared/gone .dotfiles/config/shared/kept
  > touch .dotfiles/testrc

  $ rcup >/dev/null

  $ assert_linked "$HOME/.config/solo/only" "$HOME/.dotfiles/config/solo/only"
  $ assert_linked "$HOME/.config/shared/gone" "$HOME/.dotfiles/config/shared/gone"

Retire one whole directory, one file out of a directory, and one file at the
top level

  $ rm -r .dotfiles/config/solo
  > rm .dotfiles/config/shared/gone
  > rm .dotfiles/testrc

  $ rcgc -f
  removing: */.config/shared/gone -> */.dotfiles/config/shared/gone (glob)
  removing: */.config/solo/only -> */.dotfiles/config/solo/only (glob)
  removing: */.testrc -> */.dotfiles/testrc (glob)

The links are gone

  $ refute "the top-level link should be removed" -h "$HOME/.testrc"
  $ refute "the nested link should be removed" -h "$HOME/.config/shared/gone"

A directory emptied by the collection goes with it

  $ refute "an emptied directory should be removed" -d "$HOME/.config/solo"

A directory with something left in it stays, and so does what is left

  $ assert "a directory still in use should stay" -d "$HOME/.config/shared"
  $ assert_linked "$HOME/.config/shared/kept" "$HOME/.dotfiles/config/shared/kept"

Nothing remains to collect

  $ rcgc
  clean
