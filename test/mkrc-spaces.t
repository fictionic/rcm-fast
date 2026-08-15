  $ . "$TESTDIR/helper.sh"

Should handle dotfiles with spaces

  $ touch  ".sublime text 3.config" .example 
  $ touch .some\ other.config

  $ mkrc ".sublime text 3.config" .example .some\ other.config
  '*/.dotfiles/sublime text 3.config' -> '*/.sublime text 3.config' (glob)
  '*/.dotfiles/example' -> '*/.example' (glob)
  '*/.dotfiles/some other.config' -> '*/.some other.config' (glob)

  $ assert_linked "$HOME/.sublime text 3.config" "$HOME/.dotfiles/sublime text 3.config"
  > assert_linked "$HOME/.example" "$HOME/.dotfiles/example"
  > assert_linked "$HOME/.some other.config" "$HOME/.dotfiles/some other.config"

Should handle hostnamed dotfiles with spaces

  $ touch  ".sublime text 4.config" .example2

  $ mkrc -o ".sublime text 4.config" .example2
  '*/.dotfiles/host-*/sublime text 4.config' -> '*/.sublime text 4.config' (glob)
  '*/.dotfiles/host-*/example2' -> '*/.example2' (glob)

  $ assert_linked "$HOME/.sublime text 4.config" "$HOME/.dotfiles/host-$(hostname)/sublime text 4.config"
  > assert_linked "$HOME/.example2" "$HOME/.dotfiles/host-$(hostname)/example2"

Should handle tagged dotfiles with spaces

  $ touch  ".sublime text 5.config" .example3

  $ mkrc -t whatever ".sublime text 5.config" .example3
  '*/.dotfiles/tag-whatever/sublime text 5.config' -> '*/.sublime text 5.config' (glob)
  '*/.dotfiles/tag-whatever/example3' -> '*/.example3' (glob)

  $ assert_linked "$HOME/.sublime text 5.config" "$HOME/.dotfiles/tag-whatever/sublime text 5.config"
  > assert_linked "$HOME/.example3" "$HOME/.dotfiles/tag-whatever/example3"
