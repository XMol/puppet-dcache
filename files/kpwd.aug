(* Parse kpwd files for dCache.

   For this lens to work, the configuration files have to end in
   an empty line!
*)

module Kpwd =
  autoload xfm
  
  let eol = Util.eol
  let comment = Util.comment
  let empty = Util.empty
  let sp = Sep.space
  let quot = Util.del_str "\""
  
  let label_st_regex (l:string) (r:regexp) = [ label l . store r ]
  
  let user = store Rx.word
  let uid = label_st_regex "uid" Rx.integer
  let gid = label_st_regex "gid" Rx.integer
  let home = label_st_regex "home" Rx.fspath
  let root = label_st_regex "root" Rx.fspath
  let fsroot = label_st_regex "fsroot" Rx.fspath
  let access = label_st_regex "access" /read-(only|write)/
  
  let version = [ key "version" . sp . store /[0-9.]+/ . eol ]
  
  let pwdrecord =
    let pwdhash = label_st_regex "pwdhash" /[A-Fa-f0-9]+/ in
    [ key "passwd" . sp . user . sp . pwdhash . sp . access . sp .
      uid . sp . gid . sp . home . sp . root . (sp . fsroot)? . eol
    ]
  
  let record =
    let secureid = [ label "dn" . del /[ \t]*/ "  " .
                     store /[^ \t\n][^\t\n]*[^ \t\n]/ . eol
                   ] in
    [ key "login" . sp . user . sp . access . sp .
      uid . sp . gid . sp . home . sp . root . (sp . fsroot)? . eol .
      secureid* . empty
    ]
  
  let mapping = [ key "mapping" . sp .
                  Quote.do_dquote (label_st_regex "dn" /[^"\t\n]+/) . sp .
                  store Rx.word . eol
                ]
  
  let token = ( mapping | record | pwdrecord )
    
  let lns = ( empty | comment )* . version . ( empty | comment | token )*
  
  let filter = incl "/etc/dcache/dcache.kpwd"
             . Util.stdexcl
  
  let xfm = transform lns filter
