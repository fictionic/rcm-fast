  $ . "$TESTDIR/helper.sh"

When a destination exists with different content, rcup asks before it replaces
the file

  $ echo new > .dotfiles/alpharc
  > echo old > "$HOME/.alpharc"

An unrecognized answer skips the file

  $ echo nope | rcup -v
  overwrite */.alpharc? [ynaq] skipping */.alpharc (glob)

  $ cat "$HOME/.alpharc"
  old

An answer of y replaces it

  $ echo y | rcup
  overwrite */.alpharc? [ynaq] '*/.dotfiles/alpharc' -> '*/.alpharc' (glob)

  $ assert_linked "$HOME/.alpharc" "$HOME/.dotfiles/alpharc"

An answer of Y replaces it, as does a longer answer beginning with y

  $ rm "$HOME/.alpharc"
  > echo old > "$HOME/.alpharc"

  $ echo Y | rcup
  overwrite */.alpharc? [ynaq] '*/.dotfiles/alpharc' -> '*/.alpharc' (glob)

  $ assert_linked "$HOME/.alpharc" "$HOME/.dotfiles/alpharc"

  $ rm "$HOME/.alpharc"
  > echo old > "$HOME/.alpharc"

  $ echo yes | rcup
  overwrite */.alpharc? [ynaq] '*/.dotfiles/alpharc' -> '*/.alpharc' (glob)

  $ assert_linked "$HOME/.alpharc" "$HOME/.dotfiles/alpharc"

An answer of a replaces every remaining file without asking again

  $ echo new > .dotfiles/betarc
  > rm "$HOME/.alpharc"
  > echo old > "$HOME/.alpharc"
  > echo old > "$HOME/.betarc"

  $ echo all | rcup
  overwrite */.alpharc? [ynaq] '*/.dotfiles/alpharc' -> '*/.alpharc' (glob)
  '*/.dotfiles/betarc' -> '*/.betarc' (glob)

  $ assert_linked "$HOME/.alpharc" "$HOME/.dotfiles/alpharc"
  $ assert_linked "$HOME/.betarc" "$HOME/.dotfiles/betarc"

An answer of q stops rcup

  $ rm "$HOME/.alpharc" "$HOME/.betarc"
  > echo old > "$HOME/.alpharc"
  > echo old > "$HOME/.betarc"

  $ echo quit | rcup
  overwrite */.alpharc? [ynaq]  (no-eol) (glob)
  [1]

  $ cat "$HOME/.alpharc"
  old
  $ cat "$HOME/.betarc"
  old
