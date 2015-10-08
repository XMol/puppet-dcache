(* Put this file in /usr/share/augeas/lenses/tests                          *)
(* It then may be used to verify the functionality of the lens gplazma.aug. *)

module Test_gplazma =

let conf ="# Some comment
auth    optional  x509
auth    optional  voms

map     requisite vorolemap
map     requisite authzdb authzdb=/etc/grid-security/authzdb

session requisite authzdb
"


test Gplazma.lns get conf =
  { "#comment" = "Some comment" }
  { "Stack"  = "auth"
    { "Mod"    = "optional" }
    { "Plugin" = "x509" } }
  { "Stack"  = "auth"
    { "Mod"    = "optional" }
    { "Plugin" = "voms" } }
  {}
  { "Stack"  = "map"
    { "Mod"    = "requisite" }
    { "Plugin" = "vorolemap" } }
  { "Stack"  = "map"
    { "Mod"    = "requisite" }
    { "Plugin" = "authzdb" }
    { "Param"
      { "authzdb" = "/etc/grid-security/authzdb" } } }
  {}
  { "Stack"  = "session"
    { "Mod"    = "requisite" }
    { "Plugin" = "authzdb" } }