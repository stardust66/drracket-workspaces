# DrRacket Workspaces

A DrRacket tool that lets you save multiple files as a workspace and open them
later all at once. Adds a "Workspaces" option under the file menu.

I started working on this to practice Racket and because I didn't want to
manually open all the files I need to edit every time I started up DrRacket.
This is still in an early stage but you are welcome to try it out and give
feedback! This tool was talked about in 2013 [in the Racket mailing
list](https://lists.racket-lang.org/users/archive/2013-May/057602.html) but I
don't think it got made since.

### Install
```
raco pkg install drracket-workspaces
```

### Features Implemented
- Save open tabs as a named workspace
- Clear all workspaces
- Show a dialog box with all saved workspaces

### Issues
- Not really synchronized when there are multiple windows open. Maybe this would
  be fixed if I registered a callback so that the menu was reloaded whenever
  preferences are changed.
- There is no way to delete a specific workspace. There is only an option to
  clear all of them. I need to see how other applications manage this.
