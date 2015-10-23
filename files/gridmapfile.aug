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
  
  let mapping =
    let bare = store /[^" \t\n]+/ in
    let quoted = square quot (store /[^"\n]*/) quot in
    let dn = label "dn" . (quoted|bare) in
    (* Fully Qualified Attribute Name *)
    let fqan = label "fqan" . (quoted|bare) in
    let login = Rx.word in
    [ dn . sp . [ fqan . sp . [ label "login" . store login ] ] . eol ]
    
  let lns = ( empty | comment | mapping )*
  
  let filter = incl "/etc/grid-security/grid-mapfile"
             . incl "/etc/grid-security/grid-vorolemap"
             . Util.stdexcl
  
  let xfm = transform lns filter
