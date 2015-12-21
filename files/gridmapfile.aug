(* Parse grid-mapfile or grid-vorolemap files for dCache.

   For this lens to work, the configuration files have to end in
   an empty line!
*)

module GridMapFile =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  let sp = Sep.space
  let quot = Util.del_str "\""
  
  (* Redefine dquote_spaces, because we want to disallow '#' as first
     character of a line (ambiguity with line comments). *)
  let dquote_spaces (lns:lens) =
    (* an empty pare of quotes *)
    let null = store /""/ in
    (* bare has no spaces, and is optionally quoted *)
    let bare = Quote.do_dquote_opt (store /[^" #\t\n]+/) in
    (* quoted has at least one space or is empty and must be quoted *)
    let quoted = Quote.do_dquote (store /[^"\n]*[ \t]+[^"\n]*/) in
    [ lns . bare ] | [ lns . quoted ] | [ lns . null ]
  
  let mapping =
    let dn = dquote_spaces (label "dn") in
    (* Fully Qualified Attribute Name *)
    let fqan = dquote_spaces (label "fqan") in
    let login = [ label "login" . store Rx.word ] in
    [ label "mapping" . dn . sp . (fqan . sp)? . login . eol ]

  let lns = ( empty | comment | mapping )*
  
  let filter = incl "/etc/grid-security/grid-mapfile"
             . incl "/etc/grid-security/grid-vorolemap"
             . Util.stdexcl
  
  let xfm = transform lns filter
