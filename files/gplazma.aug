(* Parse gplazma.conf files for dCache.

   For this lens to work, gplazma.conf has to end in an empty line! *)

module Gplazma =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  
  let stacks = /auth|map|account|session|identity/
  let mods = /optional|required|requisite|sufficient/
  let plugin_name = Rx.word
  let keyw = Rx.word
  let value = /[^= \t\r\n]+/
  let key_value = [ Sep.space . key keyw . Sep.equal . store value ]
  
  let plugin = [ key stacks . Sep.space
                  . [ label "Mod"  . store mods ] . Sep.space
                  . store plugin_name
                  . [ label "Param" . key_value+ ]?
                  . eol
               ]
  
  let lns = ( empty | comment | plugin )*
  
  let filter = incl "/etc/dcache/gplazma.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter