  $ . "$TESTDIR/helper.sh"

rcup makes a whole-directory link for a SYMLINK_DIRS entry, so that destination
is itself a symlink. Nothing below it belongs to rcm, and find does not descend
into a symlink given as a starting point.

  $ mkdir .dotfiles/config
  > mkdir .dotfiles/local

  $ mkdir elsewhere .local
  > ln -s "$HOME/elsewhere" .config
  > ln -s "$HOME/.dotfiles/config/gone" elsewhere/stale
  > ln -s "$HOME/.dotfiles/local/gone" .local/stale

~/.local is a real directory and becomes a haystack. ~/.config is a symlink and
does not.

  $ rcgc -nv
  scanning * (shallow)... (glob)
  scanning */.local (deep)... (glob)
  stale: */.local/stale -> */.dotfiles/local/gone (glob)
  1 stale link(s)

The -a option reaches what the symlink hides

  $ rcgc -an
  stale: */.local/stale -> */.dotfiles/local/gone (glob)
  stale: */elsewhere/stale -> */.dotfiles/config/gone (glob)
  2 stale link(s)
