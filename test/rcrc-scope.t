  $ . "$TESTDIR/helper.sh"

An rcrc cannot replace a function that rcm owns

  $ touch .dotfiles/example
  > touch .dotfiles/excluded

  $ echo 'EXCLUDES=excluded'           > $HOME/.rcrc
  $ echo 'is_excluded() { return 0; }' >> $HOME/.rcrc

  $ lsrc
  /*/.example:/*/.dotfiles/example (glob)

An rcrc cannot replace a command hook that rcm runs

  $ touch .other
  $ echo 'INSTALL="echo PWNED"' > $HOME/.rcrc

  $ mkrc .other
  '*/.dotfiles/other' -> '*/.other' (glob)

  $ assert_linked "$HOME/.other" "$HOME/.dotfiles/other"
