(* Put this file in /usr/share/augeas/lenses/tests

   It then may be used to verify the functionality of the lens
   linkgroupauthorization.
*)

module Test_linkgroupauthorization =

let conf ="#SpaceManagerLinkGroupAuthorizationFile
# this is a comment and is ignored

LinkGroup desy-test-LinkGroup
/desy/Role=test
/desy/Role=testing
tester

LinkGroup desy-anyone-LinkGroup
/desy/Role=*

LinkGroup default-LinkGroup
# allow anyone :-)
*/Role=*
"


test LinkGroupAuthorization.lns get conf =
  { "#comment" = "SpaceManagerLinkGroupAuthorizationFile" }
  { "#comment" = "this is a comment and is ignored" }
  {}
  { "LinkGroup"  = "desy-test-LinkGroup"
    { "1"    = "/desy/Role=test" }
    { "2"    = "/desy/Role=testing" }
    { "3"    = "tester" } }
  {}
  { "LinkGroup"  = "desy-anyone-LinkGroup"
    { "1"    = "/desy/Role=*" } }
  {}
  { "LinkGroup"  = "default-LinkGroup"
    { "#comment" = "allow anyone :-)" }
    { "1"    = "*/Role=*" } }
