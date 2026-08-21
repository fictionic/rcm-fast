  $ . "$TESTDIR/helper.sh"

By default rcm dots everything, so bin/ lands at ~/.bin and that is the root
rcgc derives

  $ mkdir .dotfiles/bin
  > touch .dotfiles/bin/tool
  > rcup >/dev/null

  $ assert_linked "$HOME/.bin/tool" "$HOME/.dotfiles/bin/tool"

  $ rm .dotfiles/bin/tool

  $ rcgc -n
  stale: */.bin/tool -> */.dotfiles/bin/tool (glob)
  1 stale link(s)

  $ rcgc -f
  removing: */.bin/tool -> */.dotfiles/bin/tool (glob)

UNDOTTED puts it at ~/bin instead, and the derived root follows

  $ echo 'UNDOTTED="bin"' > "$RCRC"

  $ touch .dotfiles/bin/tool
  > rcup >/dev/null

  $ assert_linked "$HOME/bin/tool" "$HOME/.dotfiles/bin/tool"

  $ rm .dotfiles/bin/tool

  $ rcgc -n
  stale: */bin/tool -> */.dotfiles/bin/tool (glob)
  1 stale link(s)

  $ rcgc -f
  removing: */bin/tool -> */.dotfiles/bin/tool (glob)

UNDOTTED is a glob list, not a list of names, and the derived root follows it

  $ echo 'UNDOTTED="b*"' > "$RCRC"

  $ touch .dotfiles/bin/tool
  > rcup >/dev/null

  $ assert_linked "$HOME/bin/tool" "$HOME/.dotfiles/bin/tool"

  $ rm .dotfiles/bin/tool

  $ rcgc -n
  stale: */bin/tool -> */.dotfiles/bin/tool (glob)
  1 stale link(s)

The answer does not depend on where rcgc was run from

  $ cd /
  > rcgc -n
  stale: */bin/tool -> */.dotfiles/bin/tool (glob)
  1 stale link(s)

Not even from a directory that holds a name which matches UNDOTTED but is
not the managed name. The globs must not expand against the caller's
directory

  $ mkdir "$HOME/decoy"
  > touch "$HOME/decoy/banana"

  $ cd "$HOME/decoy"
  > rcgc -n
  stale: */bin/tool -> */.dotfiles/bin/tool (glob)
  1 stale link(s)

  $ cd "$HOME"
  > rcgc -f
  removing: */bin/tool -> */.dotfiles/bin/tool (glob)

NEVER_UNDOTTED overrides the glob, and the root goes back to ~/.bin

  $ printf 'UNDOTTED="b*"\nNEVER_UNDOTTED="bin"\n' > "$RCRC"

  $ touch .dotfiles/bin/tool
  > rcup >/dev/null

  $ assert_linked "$HOME/.bin/tool" "$HOME/.dotfiles/bin/tool"

  $ rm .dotfiles/bin/tool

  $ rcgc -n
  stale: */.bin/tool -> */.dotfiles/bin/tool (glob)
  1 stale link(s)
