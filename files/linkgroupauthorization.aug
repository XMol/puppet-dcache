(* Parse LinkGroupAuthorization.conf files for dCache.

   For this lens to work, gplazma.conf has to end in an empty line! *)

module LinkGroupAuthorization =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  
  let group_name = Rx.word
  let title = key "LinkGroup" . Sep.space . store group_name . eol
  
  let role = /[^# \t\r\n]+/
  let entry = seq "role" . store role . eol
  
  let link_group = counter "role"
                 . [ title . comment* . [ entry ]+ ]
  
  let lns = ( empty | comment | link_group )*
  
  let filter = incl "/etc/dcache/LinkGroupAuthroization.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter