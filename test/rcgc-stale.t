  $ . "$TESTDIR/helper.sh"

rcup computes links forward-only, so deleting a file from the repo leaves its
link behind

  $ touch .dotfiles/testrc
  > rcup
  '*/.dotfiles/testrc' -> '*/.testrc' (glob)

  $ rm .dotfiles/testrc
  > rcup

  $ assert "the orphaned link should survive rcup" -h "$HOME/.testrc"

rcgc reports it

  $ rcgc -n
  stale: */.testrc -> */.dotfiles/testrc (glob)
  1 stale link(s)

Listing does not remove anything

  $ assert "the link should survive a listing" -h "$HOME/.testrc"

  $ rcgc -n
  stale: */.testrc -> */.dotfiles/testrc (glob)
  1 stale link(s)

Whitespace in a name is no obstacle

  $ touch .dotfiles/two\ words
  > rcup
  '*/.dotfiles/two words' -> '*/.two words' (glob)

  $ rm .dotfiles/two\ words

  $ rcgc -n
  stale: */.testrc -> */.dotfiles/testrc (glob)
  stale: */.two words -> */.dotfiles/two words (glob)
  2 stale link(s)
