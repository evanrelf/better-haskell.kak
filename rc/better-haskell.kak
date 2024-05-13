# Resources:
# - Indentation: https://en.wikibooks.org/wiki/Haskell/Indentation

# TODO: infixr, infixl, etc. https://wiki.haskell.org/Keywords
# TODO: -XStandaloneDeriving via (via keyword is located differently)
# TODO: Compare against existing Haskell syntax highlighting, CORRECTED to use
# the same faces
# TODO: makeLenses is highlighted like a top-level declaration
# TODO: Labels should be highlighted differently

hook global BufCreate .*[.](hs-boot|chs|hsc) %{
  set-option buffer filetype haskell
}

hook -group haskell-highlight global WinSetOption filetype=haskell %{
  hook -once global NormalIdle .* %{
    require-module better-haskell
    remove-highlighter window/haskell
    add-highlighter window/haskell ref better-haskell
  }
}

provide-module better-haskell %§

add-highlighter shared/better-haskell regions
add-highlighter shared/better-haskell/code default-region group
add-highlighter shared/better-haskell/string region '(?<![\\])"' (?<!\\)(\\\\)*" fill string
# TODO: Doesn't highlight `'_'`, `'['`, `'('` correctly
# add-highlighter shared/better-haskell/character region (?<![\\\w@])'(?!['\w\[\(]) (?<!\\)(\\\\)*' fill string
add-highlighter shared/better-haskell/comment region -recurse \{-(?!#) \{-(?!#) (?<!#)-\} fill comment
add-highlighter shared/better-haskell/line_comment region -- $ fill comment
add-highlighter shared/better-haskell/pragma region '\{-#' '#-\}' fill meta
add-highlighter shared/better-haskell/quasiquote-texp region \[\|\| \|\|\] regex (\[\|\|)(.*?)(\|\|\]) 1:keyword 2:string 3:keyword
add-highlighter shared/better-haskell/quasiquote-exp region \[\| \|\] regex (\[\|)(.*?)(\|\]) 1:keyword 2:string 3:keyword
add-highlighter shared/better-haskell/quasiquote-user-defined region \[\b(?:(?:[A-Z][\w']*\.)*)[_a-z][\w']*#?\| \|\] regex (\[)\b(?:(?:[A-Z][\w']*\.)*)[_a-z][\w']*#?(\|)(.*?)(\|\]) 1:keyword 2:keyword 3:string 4:keyword
add-highlighter shared/better-haskell/cpp-or-shebang region '^#' $ fill meta
add-highlighter shared/better-haskell/code/operator regex ('?(?:(?:[A-Z][\w']*\.)*)(?:[!#$%&\*\+\./<=>?@\\\^|\-~:]{2,}|[!#$%&\*\+/<>?\^\-:]|(?<![\w'])\.(?!\w)))(?![']) 1:operator
add-highlighter shared/better-haskell/code/top-level-binding regex ^(\w[\w']*)#?\s+ 1:function
add-highlighter shared/better-haskell/code/top-level-operator regex ^\((?<![\[])('?(?:(?:[A-Z][\w']*\.)*)(?:[!#$%&\*\+\./<=>?@\\\^|\-~:]{2,}|[!#$%&\*\+/<>?\^\-:]|(?<![\w'])\.(?!\w)))(?!['\]])\)\s+ 1:function
add-highlighter shared/better-haskell/code/keyword group
add-highlighter shared/better-haskell/code/keyword/reserved-words regex (\\case\b|(?<!\.)\b(?:case|class|data|default|deriving|do|else|foreign|if|import|in|instance|let|mdo|module|newtype|of|pattern|proc|rec|then|type|where)\b) 1:keyword
add-highlighter shared/better-haskell/code/keyword/deriving-strategies regex \bderiving\b\s+\b(stock|anyclass|via)\b 1:keyword
add-highlighter shared/better-haskell/code/keyword/deriving-via regex \bderiving\b\s+.+?\s+\b(via)\b 1:keyword
add-highlighter shared/better-haskell/code/keyword/family regex \b(?:type|data)\b\s+\b(family)\b 1:keyword
add-highlighter shared/better-haskell/code/keyword/forall regex (\bforall\b|∀)(?:\s+[a-z_][\w']*)+\s*(\.|->) 1:keyword 2:keyword
add-highlighter shared/better-haskell/code/keyword/symbols regex (!(?=\w)|(?<![\w'])_(?![\w'])|[\{\}\(\)\[\],\;]|(?<![!#$%&\*\+\./<=>?@\\\^|\-~:'])(?:[=\|\\@~](?!')|=>|->|<-|-<|-<<|::|\.\.)(?![!#$%&\*\+\./<=>?@\^|\-~:])) 1:keyword
add-highlighter shared/better-haskell/code/keyword/promotion regex ('\[|'\(|@') 1:keyword
add-highlighter shared/better-haskell/code/type regex (?<![\w'])('{0,2}(?:[A-Z][\w']*)(?:\.[A-Z][\w']*)*)(?![\.\w]) 1:type
add-highlighter shared/better-haskell/code/type-unit regex \'?\(\) 0:type
add-highlighter shared/better-haskell/code/infix regex `(?:(?:[A-Z][\w']*\.)*)\w[\w']*` 0:operator
add-highlighter shared/better-haskell/code/module group
# TODO: -XPackageImports breaks this for some reason
add-highlighter shared/better-haskell/code/module/import regex (import)(?:\s+(qualified))?(?:\s+("[\w-]*?"))?\s+([A-Z][\w']*(?:\.[A-Z][\w']*)*)(?:\s+(qualified))?(?:\s+(as)\s+([A-Z][\w']*(?:\.[A-Z][\w']*)*))?(?:\s+(hiding))?(?:\s+(\().*?(\)))? 1:keyword 2:keyword 3:string 4:module 5:keyword 6:keyword 7:module 8:keyword 9:keyword 10:keyword
add-highlighter shared/better-haskell/code/module/declaration regex (module)\s+\b((?:[A-Z][\w']*)(?:\.[A-Z][\w']*)*)(?:\s+(\().*?(\)))?(?:\s+(where))\b 1:keyword 2:module 3:keyword 4:keyword 5:keyword
add-highlighter shared/better-haskell/code/numbers group
add-highlighter shared/better-haskell/code/numbers/decimal regex ((\b|-)[0-9](?:[0-9_]*[0-9])?(?:\.[0-9](?:[0-9_]*[0-9])?)?(?:[0-9_]*e[+-]?[0-9]+)?)\b 1:value
add-highlighter shared/better-haskell/code/numbers/hexadecimal regex \b(0x[0-9a-f_]*[0-9a-f])\b 1:value
add-highlighter shared/better-haskell/code/numbers/binary regex \b(0b[01_+]*[01])\b 1:value

# TODO: -XTemplateHaskell splices (e.g. $(makeLenses ''MyType))
# TODO: -XForeignFunctionInterface keywords (e.g. foreign, ccall, prim, capi, interruptible, etc.)
# TODO: -XMagicHash / -XOverloadedLabels (#)

§
