(* Manage layout files for dCache setups. *)
(* Each layout file must end in an empty line for this lens to work properly! *)

module DCacheLayout =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  let str (s:string) = Util.del_str s
  
  let property =
    [ Util.indent . key Rx.word . Sep.space_equal . store /[^= \t\n][^\n]*/ . str "\n" ]
  
  (* The label features square brackets, so Augeas can distinct services
     from properties in the tree of a layout file (keys of properties
     may not have square brackets in them).
  *)
  let service =
    let service_name = /[A-Za-z0-9_.\${}-]+/ . /\// . Rx.word in
    let service_start = str "[" . label "[service]" . store service_name . str "]" . eol in
    [ Util.indent . service_start . property* ]
  
  (* Augeas can distinguish domains from services by their values: Only
     services have '/' in their values, domains may not.
  *)
  let domain =
    let domain_name = /[A-Za-z0-9_.\${}-]+/ in
    let domain_start = str "[" . label "[domain]" . store domain_name . str "]" . eol in
    [ Util.indent . domain_start . property* . service+ ]
  
  (* bare_properties may occur only before any domains, if at all. *)
  let lns = ( empty | comment | property )* . (domain . ( empty | comment | domain )*)?
  
  let filter = incl "/etc/dcache/layouts/*.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter
