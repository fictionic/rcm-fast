  $ . "$TESTDIR/helper.sh"

An empty dotfiles directory has nothing to collect

  $ rcgc
  clean

Neither does one whose links all still resolve

  $ touch .dotfiles/testrc
  > rcup
  '*/.dotfiles/testrc' -> '*/.testrc' (glob)

  $ rcgc
  clean

  $ assert_linked "$HOME/.testrc" "$HOME/.dotfiles/testrc"

-f has nothing to remove either, and says so the same way

  $ rcgc -f
  clean

  $ assert_linked "$HOME/.testrc" "$HOME/.dotfiles/testrc"
