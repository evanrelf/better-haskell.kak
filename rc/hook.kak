# Better Haskell syntax
# Set filetype to `haskell2` only once (allows switching back to `haskell`
# filetype)
hook global WinCreate .*\.hs %{
  hook -once window WinSetOption filetype=haskell %{
    set-option window filetype haskell2
  }
}

# Use Haskell syntax highlighting with `*.hs-boot` files
hook global WinCreate .*\.hs-boot %{
  set-option window filetype haskell
}
