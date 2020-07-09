tell application "iTerm2"
 tell current window
   create tab with profile "default"
 end tell

 tell first session of current tab of current window
   write text "cd ~/Development/github && subl oavp oavp-wiki"
   write text "cd ~/Development/github/oavp && subl $(git diff --name-only HEAD~ HEAD)"
   write text "less ~/Development/github/oavp/devnotes.txt"
   split vertically with profile "default"
 end tell

 tell second session of current tab of current window
   write text "cd ~/Development/github/oavp && git log --oneline --decorate"
 end tell
end tell
