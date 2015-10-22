(* Parse poolmanager.conf files for dCache.

   For this lens to work, poolmanager.conf has to end in an empty line!
*)

module PoolManager =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  let sp = Sep.space
  let str (s:string) = Util.del_str s
  
  (* Cost Module statements *)
  let cm = 
    let cm_param = /active|debug|magic|update/ in
    [ key "cm" . sp . str "set" . sp .
      [ key cm_param . sp . store /on|off/ ] . eol
    ]
  
  
  (* Partition Manager statements *)
  let pm =
    let ptype = [ str "-type=" . label "type" . store Rx.word ] . sp in
    let part = Rx.word in
    let pm_create = [ key "create" . sp . ptype? . store part ] in
    let n_opt = /(cpu|space)costfactor|max-copies/ |
                /fallback|halt|idle|p2p|slope|alert/ in
    let n_opt_val = /[0-9]+|[0-9]+\.[0-9]+/ in
    let w_opt = /sameHost(Copy|Retry)/ in
    let w_opt_val = /never|besteffort|notchecked/ in
    let b_opt = /p2p(-allowed|-fortransfer|-oncost)|stage-(allowed|oncost)/ in
    let b_opt_val = /yes|no/ in
    let opts = ( n_opt | w_opt | b_opt ) in
    let vals = ( n_opt_val | w_opt_val | b_opt_val ) in
    let opt = [ str "-" . key opts . str "=" . store vals ] in
    let pm_set = [ key "set" . sp . (store part . sp)? .
                   Build.opt_list opt sp ] in
    [ key "pm" . sp . ( pm_create | pm_set ) . eol ]
  
  
  (* Request Container statements *)
  let rc =
    let onerror = [ key "onerror" . sp . store /suspend|fail/ ] in
    let suspend = [ key "suspend" . sp . store /on|off/ . sp . str "-all" ] in
    let restore_set = [ str "set" . sp . key "max restore" . sp . store /[0-9]+|unlimited/ ] in
    let n_sets = /max (retries|threads)|poolpingtimer|retry/ in
    let n_set_val = /[0-9]+/ in
    let n_set = [ str "set" . sp . key n_sets . sp . store n_set_val ] in
    let w_sets = /sameHost(Copy|Retry)/ in
    let w_set_val = /never|besteffort|notchecked/ in
    let w_set = [ str "set" . sp . key w_sets . sp . store w_set_val ] in
    let rc_set = ( restore_set | n_set | w_set ) in
    [ key "rc" . sp . ( onerror | suspend | rc_set ) . eol ]
  
  
  (* Pool Selection Unit statements *)
  let unit = Rx.no_spaces
  let utype = [ label "type" . str "-" . store /net|store|dcache|protocol/ ]
  let ugroup = Rx.word
  let pool = Rx.word
  let pool_spec = [ label "attribute" . counter "attr" . 
                    [ sp . seq "attr" . str "-" . store /noping|disabled/ ]
                  ]
  let pgroup = Rx.word
  let link = Rx.word
  let lgroup = Rx.word
  
  
  let psu_create =
    let psu_create_unit = [ key "unit" . sp . utype . sp . store unit ] in
    let psu_create_ugroup = [ key "ugroup" . sp . store ugroup ] in
    let psu_create_pool = [ key "pool" . sp . store pool . pool_spec* ] in
    let psu_create_pgroup = [ key "pgroup" . sp . store pgroup ] in
    let psu_create_link = [ key "link" . sp . store link .
                            counter "ugroup" . sp .
                            Build.opt_list [ seq "ugroup" . store ugroup ] sp
                          ] in
    let psu_create_lgroup = [ key "linkGroup" . sp . store lgroup ] in
    [ key "create" . sp . ( psu_create_unit | psu_create_ugroup |
                            psu_create_pool | psu_create_pgroup |
                            psu_create_link | psu_create_lgroup )
    ]
  
  
  let psu_add =
    let add_m2g (s:string) (g:regexp) (m:regexp) = 
      [ key s . sp . [ key g . sp . store m ] ] in
    let psu_add_to_ugroup = add_m2g "ugroup" ugroup unit in
    let psu_add_to_pgroup = add_m2g "pgroup" pgroup pool in
    let psu_add_to_link = add_m2g "link" link (pool|pgroup) in
    let psu_add_to_lgroup = add_m2g "linkGroup" lgroup link in
    [
      key "addto" . sp . ( psu_add_to_ugroup | psu_add_to_pgroup | psu_add_to_lgroup ) |
      str "add" . label "addto" . sp . psu_add_to_link
    ]
  
  
  let psu_set =
    let link_prefs = /(cache|p2p|read|write)pref/ in
    let link_pref = [ str "-" . key link_prefs . str "=" . store /-?[0-9]+/ ] in
    let link_section = [ str "-" . key "section" . str "=" . store Rx.word ] in
    let psu_set_link = [ key "link" . sp . store link . sp .
                         Build.opt_list (link_pref|link_section) sp
                       ] in
    let access_latency = /(on|near)line/ in
    let retention_policy = /custodial|output|replica/ in
    let lg_allow = (access_latency|retention_policy)./Allowed/ in
    let psu_set_lgroup = [ key "linkGroup" . sp .
                           [ key lg_allow . sp .
                             [ key lgroup . sp . store /true|false/ ]
                           ]
                         ] in
    let pool_state = /(en|dis)abled|(no)?ping|(not)?rdonly/ in
    let psu_set_pool = [ key "pool" . sp .
                         [ key pool . sp . store pool_state ]
                       ] in
    let psu_set_pool_active =
        [ key "allpoolsactive" . sp . store /on|off/ ] |
        [ key "active" . sp . store (pool|"*") .
          [ sp . str "-" . store "no" ]?
        ] in
    let psu_set_pool_enabled = [ key /(en|dis)abled/ . sp . store pool ] in
    let psu_set_regex = [ key "regex" . sp . store /on|off/ ] in
    let psu_set_other = ( psu_set_pool_active | psu_set_pool_enabled |
                          psu_set_regex ) in
    [ key "set" . sp .
      ( psu_set_link | psu_set_lgroup | psu_set_pool | psu_set_other )
    ]
  
  let psu = [ key "psu" . sp . ( psu_add | psu_create | psu_set ) . eol ]
  
  
  let lns = ( empty | comment | psu | rc | cm | pm )*
  
  let filter = incl "/var/lib/dcache/config/poolmanager.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter
