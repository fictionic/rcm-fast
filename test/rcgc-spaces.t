  $ . "$TESTDIR/helper.sh"

Should find stale links under a directory with whitespace in its name

  $ mkdir .dotfiles/sub\ dir
  > touch .dotfiles/sub\ dir/example
  > rcup >/dev/null

  $ assert_linked "$HOME/.sub dir/example" "$HOME/.dotfiles/sub dir/example"

  $ rm .dotfiles/sub\ dir/example

  $ rcgc -n
  stale: */.sub dir/example -> */.dotfiles/sub dir/example (glob)
  1 stale link(s)

Two such names, where one starts with another in full, stay apart. The root
layer is read before the tag layers, so the longer name is recorded first

  $ mkdir .dotfiles/foo\ bar .dotfiles/tag-x
  > mkdir .dotfiles/tag-x/foo
  > touch .dotfiles/foo\ bar/a .dotfiles/tag-x/foo/b
  > rcup -t x >/dev/null

  $ assert_linked "$HOME/.foo bar/a" "$HOME/.dotfiles/foo bar/a"
  $ assert_linked "$HOME/.foo/b" "$HOME/.dotfiles/tag-x/foo/b"

  $ rm .dotfiles/foo\ bar/a .dotfiles/tag-x/foo/b

  $ rcgc -nv 2>&1 | grep scanning
  scanning * (shallow)... (glob)
  scanning */.foo bar (deep)... (glob)
  scanning */.sub dir (deep)... (glob)
  scanning */.foo (deep)... (glob)

  $ rcgc -n
  stale: */.foo bar/a -> */.dotfiles/foo bar/a (glob)
  stale: */.foo/b -> */.dotfiles/tag-x/foo/b (glob)
  stale: */.sub dir/example -> */.dotfiles/sub dir/example (glob)
  3 stale link(s)
