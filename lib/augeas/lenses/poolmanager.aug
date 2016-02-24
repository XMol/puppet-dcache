(* Parse poolmanager.conf files for dCache.*)

module PoolManager =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  let sp = Sep.space
  let str (s:string) = del s s
  
  (* Cost Module statements *)
  let cm_set (s:string) = 
    [ label ("cm_".s) . del (/cm[ \t]+set[ \t]+/.s) ("cm set ".s) . sp .
      store /on|off/ . eol ]
  
  let cm =
    let cm_active = cm_set "active" in
    let cm_debug = cm_set "debug" in
    let cm_magic = cm_set "magic" in
    let cm_update = cm_set "update" in
    cm_active | cm_debug | cm_magic | cm_update
  
  (* Partition Manager statements *)
  let partition = Rx.word
  let pm_create =
    let ptype = [ str "-type=" . label "type" . store Rx.word ] in
    label "pm_create" . del /pm[ \t]+create/ "pm create" . sp .
    (ptype . sp)? . store partition
  
  (* Since dCache supports custom partitions, not just those shipped with it,
     we have to accept any kind of partition parameter and value. *)
  let pm_set =
    let param_key = Rx.word in
    let param_val = Rx.word in
    let param = [ str "-" . key param_key . str "=" . store param_val ] in
    label "pm_set" . del /pm[ \t]+set/ "pm set" . sp .
    (store partition . sp)? . Build.opt_list param sp
  
  let pm = [ pm_create . eol ] | [ pm_set . eol ]
  
  
  (* Request Container statements *)
  let rc_set_onerror =
    [ label "rc_set_onerror" . del /rc[ \t]+onerror/ "rc onerror" . sp .
      store /suspend|fail/ . eol ]
  
  let rc_set (s:string) (v:regexp) =
    [ label ("rc_set_".s) . del (/rc[ \t]+set[ \t]+/.s) ("rc set ".s) . sp .
      store v . eol ]
  
  let rc_set_max (s:string) (r:regexp) =
    [ label ("rc_set_max_".s) .
      del (/rc[ \t]+set[ \t]+max[ \t]+/.s) ("rc set max ".s) . sp .
      store r . eol ]
  
  let rc = (
    rc_set_onerror |
    rc_set_max "restore" /[0-9]+|unlimited/ |
    rc_set_max "retries" /[0-9]+/ | rc_set_max "threads" /[0-9]+/ |
    rc_set "poolpingtimer" /[0-9]+/ | rc_set "retry" /[0-9]+/ |
    rc_set "sameHostCopy" /never|besteffort|notchecked/ |
    rc_set "sameHostRetry" /never|besteffort|notchecked/
  )
  
  
  (* Pool Selection Unit statements *)
  let unit = Rx.no_spaces
  let ugroup = Rx.word
  let pool = Rx.word
  let pgroup = Rx.word
  let link = Rx.word
  let lgroup = Rx.word
  
  let psu_do (t:string) (r:regexp) (s:string) (l:lens) =
    [ label t . del (/psu[ \t]+/.r) ("psu ".s) . l ]
  
  let psu_create (s:string) (l:lens) =
    psu_do ("psu_create_".s) (/create[ \t]+/.s./[ \t]+/) ("create ".s." ") l

  let psu_create_unit =
    let utype = [ label "type" . str "-" . store /net|store|dcache|protocol/ ] in
    psu_create "unit" ( utype . sp . store unit )
  
  let psu_create_ugroup =
    psu_create "ugroup" ( store ugroup )
  
  let psu_create_pool =
    let attr = [ seq "attr" . sp . str "-" . store /noping|disabled/ ] in
    psu_create "pool" ( store pool . counter "attr" . ( attr . attr? )? )

  let psu_create_pgroup =
    psu_create "pgroup" ( store pgroup )
  
  let psu_create_link =
    psu_create "link" ( store link . sp . Build.opt_list [ label "ugroup" . store ugroup ] sp )

  let psu_create_lgroup =
    psu_create "linkGroup" ( store lgroup )
  
  
  let psu_addto (s:string) (g:regexp) (m:regexp) =
    psu_do ("psu_addto_".s) (/addto[ \t]+/.s./[ \t]+/) ("addto ".s." ") ( store g . sp . [ label "1" . store m ] )

  let psu_addto_ugroup =
    psu_addto "ugroup" ugroup unit

  let psu_addto_pgroup =
    psu_addto "pgroup" pgroup pool

  let psu_addto_link =
    psu_do ("psu_addto_link") (/add[ \t]+link[ \t]+/) ("add link ") ( store link . sp . [ label "1" . store pgroup ] )

  let psu_addto_lgroup =
    psu_addto "linkGroup" lgroup link

    
  let psu_set (s:string) (l:lens) =
    psu_do ("psu_set_".s) (/set[ \t]+/.s./[ \t]+/) ("set ".s." ") l

  let psu_set_link =
    let link_prefs = key /(cache|p2p|read|write)/ . del "pref" "pref" in
    let link_pref = [ str "-" . link_prefs . str "=" . store /-?[0-9]+/ ] in
    let link_section = [ str "-" . key "section" . str "=" . store Rx.word ] in
    psu_set "link" ( store link . sp . Build.opt_list (link_pref|link_section) sp )
  
  let psu_set_lgroup (s:string) =
    psu_do ("psu_set_linkGroup_".s) (/set[ \t]+linkGroup[ \t]+/.s./Allowed[ \t]+/) ("set linkGroup ".s."Allowed ") ( store lgroup . sp . [ label "1" . store /true|false/ ] )

  let psu_set_lgroup_custodial = psu_set_lgroup "custodial"
  let psu_set_lgroup_replica = psu_set_lgroup "replica"
  let psu_set_lgroup_output = psu_set_lgroup "output"
  let psu_set_lgroup_online = psu_set_lgroup "online"
  let psu_set_lgroup_nearline = psu_set_lgroup "nearline"
  
  let psu_set_pool = psu_set "pool" (
    store (pool."*") . sp .
    [ label "1" . store /(en|dis)abled|(no)?ping|(not)?rdonly/ ]
  )

  let psu_set_pool_allpoolsactive =
    psu_set "allpoolsactive" ( store /on|off/ )
  
  let psu_set_pool_active =
    psu_set "active" ( store (pool|"*") . [ sp . label "1" . str "-" . store "no" ]? )

  (* Allow globbing for pool names *)
  let psu_set_pool_enabled =
    psu_set "enabled" ( store (pool."*") )
  let psu_set_pool_disabled =
    psu_set "disabled" ( store (pool."*") )

  let psu_set_regex =
    psu_set "regex" ( store /on|off/ )

  let psu_add_any =
    ( psu_addto_ugroup | psu_addto_pgroup | psu_addto_link | psu_addto_lgroup )

  let psu_create_any =
    ( psu_create_unit | psu_create_ugroup |
      psu_create_pool | psu_create_pgroup |
      psu_create_link | psu_create_lgroup )
  
  let psu_set_any =
    ( psu_set_link | psu_set_regex |
      psu_set_lgroup_custodial | psu_set_lgroup_replica |
      psu_set_lgroup_nearline | psu_set_lgroup_online | psu_set_lgroup_output |
      psu_set_pool_active | psu_set_pool_allpoolsactive |
      psu_set_pool | psu_set_pool_enabled |  psu_set_pool_disabled )

  let psu = ( psu_add_any | psu_create_any | psu_set_any ) . eol  
  
  let lns = ( empty | comment | psu | rc | cm | pm )*
  
  let filter = incl "/var/lib/dcache/config/poolmanager.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter
