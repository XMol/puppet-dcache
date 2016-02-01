(* Parse storage-authzdb files for dCache. *)

module StorageAuthzdb =
  autoload xfm
  
  let comment = Util.comment
  let empty = Util.empty
  let eol = Util.eol
  let sp = Sep.space
  
  let version = [ key "version" . sp . store /2\.[12]/ . eol ]
  
  let rule =
    let user = Rx.word in
    let access = /read-(only|write)/ in
    let uid = /[0-9]+/ in
    let gid = /[0-9]+/ in
    let comma = Util.del_str "," in
    let home = Rx.no_spaces in
    let root = Rx.no_spaces in
    let extra = Rx.no_spaces in
    [ Util.del_str "authorize" . sp .
      key user . sp .
      [ label "access" . store access ] . sp .
      [ label "uid" . store uid ] . sp .
      Build.opt_list [ label "gid" . store gid ] comma . sp .
      [ label "home" . store home ] . sp .
      [ label "root" . store root ] .
      [ sp . label "extra" . store extra ]? .
      eol
    ]
  
  
  let lns = (( empty | comment )* . version . ( empty | comment | rule )*)?
  
  let filter = incl "/etc/grid-security/storage-authzdb"
             . Util.stdexcl
  
  let xfm = transform lns filter
