(* Put this file in /usr/share/augeas/lenses/tests

   It then may be used to verify the functionality of the lens
   linkgroupauthorization.
*)

module Test_linkgroupauthorization =

let conf = "
#SpaceManagerLinkGroupAuthorizationFile
# this is a comment and is ignored

LinkGroup test-LinkGroup
  /some/Role=test
  /some/Role=testing

tester

LinkGroup anyone-LinkGroup
LinkGroup default-LinkGroup
# allow anyone :-)
*/Role=*
"


test LinkGroupAuthorization.lns get conf =
{ }
{ "#comment" = "SpaceManagerLinkGroupAuthorizationFile" }
{ "#comment" = "this is a comment and is ignored" }
{ }
{ "LinkGroup"  = "test-LinkGroup"
  { "entry"    = "/some/Role=test" }
  { "entry"    = "/some/Role=testing" }
  { }
  { "entry"    = "tester" }
}
{ }
{ "LinkGroup"  = "anyone-LinkGroup" }
{ "LinkGroup"  = "default-LinkGroup"
  { "#comment" = "allow anyone :-)" }
  { "entry"    = "*/Role=*" }
}


test LinkGroupAuthorization.lns put conf after
  set "LinkGroup[. = \"anyone-LinkGroup\"]/entry" "somebody" = "
#SpaceManagerLinkGroupAuthorizationFile
# this is a comment and is ignored

LinkGroup test-LinkGroup
  /some/Role=test
  /some/Role=testing

tester

LinkGroup anyone-LinkGroup
  somebody
LinkGroup default-LinkGroup
# allow anyone :-)
*/Role=*
"
