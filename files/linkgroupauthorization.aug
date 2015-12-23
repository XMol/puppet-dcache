(* Parse LinkGroupAuthorization.conf files for dCache.

   For this lens to work, gplazma.conf has to end in an empty line! *)

module LinkGroupAuthorization =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  let sp = Sep.space
  
  let link_group =
    let group_name = Rx.word in
    let title = key "LinkGroup" . sp . store group_name . eol in
    let role = /[^# \t\r\n]+/ in
    let entry = [ del /[ \t]*/ "  " . label "entry" . store role . eol ] in
    [ title . ((entry|empty|comment)* . entry)? ]
  
  let lns = ( empty | comment | link_group )*
  
  let filter = incl "/etc/dcache/LinkGroupAuthorization.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter
