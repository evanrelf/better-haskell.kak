hook global WinCreate .*\.hs(?:-boot)? %{
  set-option window filetype haskell
  hook -once window WinSetOption filetype=haskell %{
    set-option window filetype haskell2
  }
}
