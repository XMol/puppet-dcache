(* Parse gplazma.conf files for dCache.*)

module Gplazma =
  autoload xfm
  
  let eol = Util.eol
  let filler = Util.comment | Util.empty
  let sp = Sep.space
  
  let rule =
    let stack = /auth|map|account|session|identity/ in
    let modifier = /optional|required|requisite|sufficient/ in
    let plugin = Rx.word in
    let parameter = Quote.do_dquote (Build.key_value Rx.word Sep.equal (store /[^"]+/)) in
    [ key stack . sp .
      [ key modifier . sp . store plugin .
        ( sp . Build.opt_list parameter sp )? . eol
      ]
    ]

  let lns = ( filler | rule )*
  
  let filter = incl "/etc/dcache/gplazma.conf"
             . Util.stdexcl
  
  let xfm = transform lns filter
