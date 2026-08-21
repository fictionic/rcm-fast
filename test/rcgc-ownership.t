  $ . "$TESTDIR/helper.sh"

Ownership is decided by where a link points, never by where it lives.
Set up one link of each kind alongside a genuine orphan.

  $ touch .dotfiles/testrc
  > touch .dotfiles/keeprc
  > rcup >/dev/null
  > rm .dotfiles/testrc

A broken link out to somewhere we do not manage

  $ ln -s /nonexistent/elsewhere "$HOME/.foreign"

A broken relative link; rcm only ever writes absolute targets, so this one was
written by something else

  $ ln -s ../nonexistent "$HOME/.relative"

A directory whose name merely starts with the repo's

  $ mkdir "$HOME/.dotfiles-old"
  > ln -s "$HOME/.dotfiles-old/gone" "$HOME/.prefix"

Only the orphan pointing into the repo is ours

  $ rcgc -n
  stale: */.testrc -> */.dotfiles/testrc (glob)
  1 stale link(s)

  $ rcgc -f
  removing: */.testrc -> */.dotfiles/testrc (glob)

Everything else is left exactly as it was, including the link whose source
still exists

  $ assert "a foreign target is not ours" -h "$HOME/.foreign"
  $ assert "a relative target is not ours" -h "$HOME/.relative"
  $ assert "a prefix match is not a match" -h "$HOME/.prefix"
  $ assert_linked "$HOME/.keeprc" "$HOME/.dotfiles/keeprc"

  $ rcgc
  clean

Links inside the repo are the repo's business, not ours

  $ ln -s "$HOME/.dotfiles/gone" .dotfiles/internal

  $ rcgc
  clean

  $ assert "a link inside the repo is pruned" -h "$HOME/.dotfiles/internal"
