  $ . "$TESTDIR/helper.sh"

test/rcgc-force.t covers the directory that held the link. Each empty
directory above it goes as well, the way rcdn(1) does

  $ mkdir -p .dotfiles/config/alone/inner
  > touch .dotfiles/config/alone/inner/only
  > rcup >/dev/null

  $ rm .dotfiles/config/alone/inner/only

  $ rcgc -f
  removing: */.config/alone/inner/only -> */.dotfiles/config/alone/inner/only (glob)

  $ refute "the directory that held the link should go" -d "$HOME/.config/alone/inner"
  $ refute "its emptied parent should go too" -d "$HOME/.config/alone"

A directory straight in $HOME is left alone, even once it is empty. The system
or another program may want it there

  $ assert "the top-level destination should stay" -d "$HOME/.config"

The walk up stops at a directory that still holds something

  $ mkdir -p .dotfiles/config/mixed/inner
  > touch .dotfiles/config/mixed/inner/only
  > touch .dotfiles/config/mixed/stays
  > rcup >/dev/null

  $ rm .dotfiles/config/mixed/inner/only

  $ rcgc -f
  removing: */.config/mixed/inner/only -> */.dotfiles/config/mixed/inner/only (glob)

  $ refute "the emptied directory should go" -d "$HOME/.config/mixed/inner"
  $ assert "a directory still in use should stay" -d "$HOME/.config/mixed"
  $ assert_linked "$HOME/.config/mixed/stays" "$HOME/.dotfiles/config/mixed/stays"

Directories that rcgc did not empty are untouched

  $ mkdir -p "$HOME/.config/mine_empty"

  $ rcgc -f
  clean

  $ assert "an unrelated empty directory should stay" -d "$HOME/.config/mine_empty"

The walk up never reaches $HOME, however empty it gets

  $ mkdir .dotfiles/lonerc-dir
  > touch .dotfiles/lonerc-dir/only
  > rcup >/dev/null

  $ rm -r .dotfiles/lonerc-dir

  $ rcgc -a -f
  removing: */.lonerc-dir/only -> */.dotfiles/lonerc-dir/only (glob)

  $ assert "a directory straight in \$HOME should stay" -d "$HOME/.lonerc-dir"
  $ assert "\$HOME should still be there" -d "$HOME"
