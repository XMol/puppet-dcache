(* Manage layout files for dCache setups. *)

module DCacheLayout =
  autoload xfm
  
  let eol = Util.eol
  let filler = Util.comment | Util.empty
  let str (s:string) = Util.del_str s
  
  let property =
    Build.key_value_line Rx.word Sep.space_equal (store Rx.space_in)
  let bare_properties =
    let opt_ws_prop = del /[ \t]*/ "" . property in
    [ label "properties" . (filler | opt_ws_prop)* . opt_ws_prop ] . str "\n"
  let properties =
    let indent_prop = del /[ \t]*/ "  " . property in
    [ label "properties" . (filler | indent_prop)* . indent_prop ]
  
  let service =
    let service_name = /[A-Za-z0-9_.${}-]+\// . Rx.word in
    let service_start =
        str "[" . label "service" . store service_name . str "]" . eol in
    [ Util.indent . service_start . properties? ]
  
  let domain =
    let domain_name = /[A-Za-z0-9_.${}-]+/ in
    let domain_start =
        str "[" . label "domain" . store domain_name . str "]" . eol in
    [ Util.indent . domain_start . properties? .
      (( service | filler )* . service)
    ] . str "\n"
  
  let lns = ( bare_properties? . ( filler | domain )* )?
  
  let filter = incl "/etc/dcache/layouts/*.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter
