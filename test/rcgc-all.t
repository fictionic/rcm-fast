  $ . "$TESTDIR/helper.sh"

Retiring a whole tree leaves its root underived. Nothing in the repo implies
~/.config once config/ is gone, so the orphans beneath it go unseen.

  $ mkdir -p .dotfiles/config/nvim
  > touch .dotfiles/config/nvim/init.lua
  > rcup >/dev/null
  > rm -r .dotfiles/config

  $ assert "the orphan is still on disk" -h "$HOME/.config/nvim/init.lua"

  $ rcgc
  clean

-a walks all of $HOME and finds it

  $ rcgc -n -a
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  1 stale link(s)

Links inside the repo are pruned from the walk even under -a

  $ ln -s "$HOME/.dotfiles/gone" .dotfiles/internal

  $ rcgc -n -a
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  1 stale link(s)

  $ assert "a link inside the repo is left alone" -h "$HOME/.dotfiles/internal"

-a removes with -f like any other run

  $ rcgc -a -f
  removing: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)

  $ refute "the orphan should be gone" -h "$HOME/.config/nvim/init.lua"
  $ refute "the emptied directory should be gone" -d "$HOME/.config/nvim"

  $ rcgc -a
  clean
