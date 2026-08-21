  $ . "$TESTDIR/helper.sh"

Roots are derived from tag- and host- layers as well as the repo root

  $ mkdir -p .dotfiles/tag-gui/themes
  > touch .dotfiles/tag-gui/themes/dark
  > mkdir -p .dotfiles/host-$(hostname)/ssh
  > touch .dotfiles/host-$(hostname)/ssh/config

  $ rcup -t gui >/dev/null

  $ assert_linked "$HOME/.themes/dark" "$HOME/.dotfiles/tag-gui/themes/dark"
  $ assert_linked "$HOME/.ssh/config" "$HOME/.dotfiles/host-$(hostname)/ssh/config"

  $ rm .dotfiles/tag-gui/themes/dark
  > rm .dotfiles/host-$(hostname)/ssh/config

rcgc takes no -t, so a layer is searched whatever tags happen to be active

  $ rcgc -n
  stale: */.ssh/config -> */.dotfiles/host-*/ssh/config (glob)
  stale: */.themes/dark -> */.dotfiles/tag-gui/themes/dark (glob)
  2 stale link(s)

A destination implied by more than one layer is searched once, not twice

  $ mkdir -p .dotfiles/themes
  > touch .dotfiles/themes/light
  > rcup >/dev/null
  > rm .dotfiles/themes/light

  $ rcgc -n
  stale: */.ssh/config -> */.dotfiles/host-*/ssh/config (glob)
  stale: */.themes/dark -> */.dotfiles/tag-gui/themes/dark (glob)
  stale: */.themes/light -> */.dotfiles/themes/light (glob)
  3 stale link(s)
