  $ . "$TESTDIR/helper.sh"

A haystack that is shared with the operating system can hold a great deal that
is not ours. Library/ here stands in for ~/Library on macOS: the dotfiles
directory names one directory in it, and something else owns the rest

  $ printf 'UNDOTTED="Library"\n' > "$RCRC"
  > mkdir -p .dotfiles/Library/LaunchAgents
  > touch .dotfiles/Library/LaunchAgents/agent.plist
  > rcup >/dev/null

  $ assert_linked "$HOME/Library/LaunchAgents/agent.plist" "$HOME/.dotfiles/Library/LaunchAgents/agent.plist"

  $ mkdir -p "$HOME/Library/Caches/deep"
  > ln -s "$HOME/.dotfiles/Library/Caches/deep/gone" "$HOME/Library/Caches/deep/orphan"

By default the whole haystack is searched, so the link under Caches is found

  $ rm .dotfiles/Library/LaunchAgents/agent.plist

  $ rcgc -n
  stale: */Library/Caches/deep/orphan -> */.dotfiles/Library/Caches/deep/gone (glob)
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  2 stale link(s)

GC_SHALLOW_DIRS stops the search at the top of the haystack, and then searches
only the destinations one level below it that the dotfiles directory names

  $ printf 'UNDOTTED="Library"\nGC_SHALLOW_DIRS="Library"\n' > "$RCRC"

  $ rcgc -n
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  1 stale link(s)

A link at the top of a shallow haystack is still ours

  $ touch .dotfiles/Library/toprc
  > rcup >/dev/null
  > rm .dotfiles/Library/toprc

  $ rcgc -n
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  stale: */Library/toprc -> */.dotfiles/Library/toprc (glob)
  2 stale link(s)

  $ rm "$HOME/Library/toprc"

A named directory below a shallow haystack is searched all the way down, so a
directory retired inside it needs no -a

  $ mkdir -p .dotfiles/Library/LaunchAgents/nested
  > touch .dotfiles/Library/LaunchAgents/nested/deep.plist
  > rcup >/dev/null

  $ assert_linked "$HOME/Library/LaunchAgents/nested/deep.plist" "$HOME/.dotfiles/Library/LaunchAgents/nested/deep.plist"

  $ rm -r .dotfiles/Library/LaunchAgents/nested

  $ rcgc -n
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  stale: */Library/LaunchAgents/nested/deep.plist -> */.dotfiles/Library/LaunchAgents/nested/deep.plist (glob)
  2 stale link(s)

  $ rm -r "$HOME/Library/LaunchAgents/nested"

-a searches everything, whatever GC_SHALLOW_DIRS says

  $ rcgc -n -a
  stale: */Library/Caches/deep/orphan -> */.dotfiles/Library/Caches/deep/gone (glob)
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  2 stale link(s)

Only the named haystack goes shallow. The others are searched as before

  $ mkdir -p .dotfiles/config/nvim
  > touch .dotfiles/config/nvim/init.lua
  > rcup >/dev/null
  > rm -r .dotfiles/config/nvim

  $ rcgc -n
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  2 stale link(s)

GC_SHALLOW_DIRS is a list of patterns, not a list of names

  $ printf 'UNDOTTED="Library"\nGC_SHALLOW_DIRS="Lib*"\n' > "$RCRC"

  $ rcgc -n
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  2 stale link(s)

A shallow haystack that a tag layer contributes to behaves the same way

  $ printf 'UNDOTTED="Library"\nGC_SHALLOW_DIRS="Library"\n' > "$RCRC"
  > mkdir -p .dotfiles/tag-mac/Library/Preferences
  > touch .dotfiles/tag-mac/Library/Preferences/prefs.plist
  > rcup -t mac >/dev/null

  $ assert_linked "$HOME/Library/Preferences/prefs.plist" "$HOME/.dotfiles/tag-mac/Library/Preferences/prefs.plist"

  $ rm .dotfiles/tag-mac/Library/Preferences/prefs.plist

  $ rcgc -n
  stale: */.config/nvim/init.lua -> */.dotfiles/config/nvim/init.lua (glob)
  stale: */Library/LaunchAgents/agent.plist -> */.dotfiles/Library/LaunchAgents/agent.plist (glob)
  stale: */Library/Preferences/prefs.plist -> */.dotfiles/tag-mac/Library/Preferences/prefs.plist (glob)
  3 stale link(s)

The scope is reported at -v

  $ rcgc -n -v 2>&1 | grep scanning | sort
  scanning * (shallow)... (glob)
  scanning */.config (deep)... (glob)
  scanning */Library (shallow)... (glob)
  scanning */Library/LaunchAgents (deep)... (glob)
  scanning */Library/Preferences (deep)... (glob)

A directory below a shallow one can be capped as well, by naming its path.
Naming a path implies its ancestors, so Library needs no entry of its own. A
space cannot appear in one of these lists, so ? stands in for the one in
Application Support

  $ mkdir -p ".dotfiles/Library/Application Support/Code/User"
  > touch ".dotfiles/Library/Application Support/Code/User/settings.json"
  > rcup >/dev/null

  $ printf 'UNDOTTED="Library"\nGC_SHALLOW_DIRS="Library/Application?Support"\n' > "$RCRC"

  $ rcgc -n -v 2>&1 | grep scanning | sort
  scanning * (shallow)... (glob)
  scanning */.config (deep)... (glob)
  scanning */Library (shallow)... (glob)
  scanning */Library/Application Support (shallow)... (glob)
  scanning */Library/Application Support/Code (deep)... (glob)
  scanning */Library/LaunchAgents (deep)... (glob)
  scanning */Library/Preferences (deep)... (glob)

Code stays deep, so a directory retired from inside it still needs no -a

  $ rm -r ".dotfiles/Library/Application Support/Code/User"

  $ rcgc -n | grep settings
  stale: */Library/Application Support/Code/User/settings.json -> */.dotfiles/Library/Application Support/Code/User/settings.json (glob)

A * spans a / here, as it does in the other pattern variables, so a trailing one
caps the whole subtree

  $ printf 'UNDOTTED="Library"\nGC_SHALLOW_DIRS="Library/Application*"\n' > "$RCRC"

  $ rcgc -n -v 2>&1 | grep "^scanning.*Application Support" | sort
  scanning */Library/Application Support (shallow)... (glob)
  scanning */Library/Application Support/Code (shallow)... (glob)

The name alone reaches it too, once an ancestor is shallow

  $ printf 'UNDOTTED="Library"\nGC_SHALLOW_DIRS="Library Application?Support"\n' > "$RCRC"

  $ rcgc -n -v 2>&1 | grep "^scanning.*Application Support" | sort
  scanning */Library/Application Support (shallow)... (glob)
  scanning */Library/Application Support/Code (deep)... (glob)
