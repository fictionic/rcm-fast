  $ . "$TESTDIR/helper.sh"

A hooks, tag- or host- directory at the top of a dotfiles directory names no
destination, so rcgc does not search the ~/.hooks, ~/.tag-* or ~/.host-* that
shares its name

  $ mkdir .dotfiles/hooks
  > mkdir .dotfiles/tag-gui
  > mkdir .dotfiles/config

The links are made by hand. rcup would run the hooks directory.

  $ mkdir .hooks .tag-gui .config
  > ln -s "$HOME/.dotfiles/hooks/gone"   .hooks/stale
  > ln -s "$HOME/.dotfiles/tag-gui/gone" .tag-gui/stale
  > ln -s "$HOME/.dotfiles/config/gone"  .config/stale

Only ~/.config is in scope

  $ rcgc -n
  stale: */.config/stale -> */.dotfiles/config/gone (glob)
  1 stale link(s)

The -a option reaches the rest

  $ rcgc -an
  stale: */.config/stale -> */.dotfiles/config/gone (glob)
  stale: */.hooks/stale -> */.dotfiles/hooks/gone (glob)
  stale: */.tag-gui/stale -> */.dotfiles/tag-gui/gone (glob)
  3 stale link(s)

The rule applies to the top of a dotfiles directory only, so a hooks directory
inside a host- layer still names ~/.hooks

  $ mkdir -p .dotfiles/host-foo/hooks

  $ rcgc -n
  stale: */.config/stale -> */.dotfiles/config/gone (glob)
  stale: */.hooks/stale -> */.dotfiles/hooks/gone (glob)
  2 stale link(s)
