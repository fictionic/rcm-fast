  $ . "$TESTDIR/helper.sh"

The trees searched are derived from the repo layout. config/ in the repo
implies ~/.config, so an orphan under it is in scope.

  $ mkdir -p .dotfiles/config/nvim
  > touch .dotfiles/config/nvim/init.lua
  > rcup >/dev/null
  > rm -r .dotfiles/config/nvim

Nothing in the repo implies ~/.local, so an identical orphan there is not.

  $ mkdir -p "$HOME/.local/state"
  > ln -s "$HOME/.dotfiles/local/state/gone" "$HOME/.local/state/orphan"

  $ rcgc -n
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  1 stale link(s)

Give the repo a local/ entry and ~/.local comes into scope

  $ mkdir .dotfiles/local

  $ rcgc -n
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  stale: */.local/state/orphan -> */.dotfiles/local/state/gone (glob)
  2 stale link(s)

A repo entry whose destination does not exist contributes no root

  $ mkdir .dotfiles/nowhere

  $ refute "the destination should not exist" -d "$HOME/.nowhere"

  $ rcgc -n
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  stale: */.local/state/orphan -> */.dotfiles/local/state/gone (glob)
  2 stale link(s)
