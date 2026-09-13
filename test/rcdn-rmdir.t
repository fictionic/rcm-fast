  $ . "$TESTDIR/helper.sh"

Removing the last file in a directory removes that directory, and each empty
directory above it

  $ mkdir -p .dotfiles/config/alone/inner
  > touch .dotfiles/config/alone/inner/only
  > rcup >/dev/null

  $ assert_linked "$HOME/.config/alone/inner/only" "$HOME/.dotfiles/config/alone/inner/only"

  $ rcdn >/dev/null

  $ refute "the directory that held the file should go" -d "$HOME/.config/alone/inner"
  $ refute "its emptied parent should go too" -d "$HOME/.config/alone"

A directory straight in $HOME is left alone, even once it is empty. The system
or another program may want it there, and rcm did not make it

  $ assert "the top-level destination should stay" -d "$HOME/.config"

The walk up stops at a directory that still holds something

  $ mkdir -p .dotfiles/config/mixed/inner
  > touch .dotfiles/config/mixed/inner/only
  > rcup >/dev/null
  > touch "$HOME/.config/mixed/unmanaged"

  $ rcdn >/dev/null

  $ refute "the emptied directory should go" -d "$HOME/.config/mixed/inner"
  $ assert "a directory still in use should stay" -d "$HOME/.config/mixed"

Directories that rcdn did not empty are untouched

  $ mkdir -p "$HOME/.config/mine_empty"
  > rcdn >/dev/null

  $ assert "an unrelated empty directory should stay" -d "$HOME/.config/mine_empty"
