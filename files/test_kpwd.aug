(* Put this file into /usr/share/augeas/lenses/tests, then one may test
   the functionality of the Kpwd augeas module.
*)

module Test_kpwd =

let conf =
"# Some comment
version 2.1
mapping \"/C=DE/CN=John Doe\" john
mapping \"/C=DE/CN=Michael Smith\" michael

# the following are the user auth records
login admin read-write 600 600 / / /
  /C=DE/CN=Susie Somebody
  /C=DE/CN=Anne Anonymous

# the following are the user password records
passwd admin b0da6de6 read-write 600 600 / /
"


test Kpwd.lns get conf =
{ "#comment" = "Some comment" }
{ "version" = "2.1" }
{ "mapping" = "john"
  { "dn" = "/C=DE/CN=John Doe" }
}
{ "mapping" = "michael"
  { "dn" = "/C=DE/CN=Michael Smith" }
}
{}
{ "#comment" = "the following are the user auth records" }
{ "login" = "admin"
  { "access" = "read-write" }
  { "uid" = "600" }
  { "gid" = "600" }
  { "home" = "/" }
  { "root" = "/" }
  { "fsroot" = "/" }
  { "dn" = "/C=DE/CN=Susie Somebody" }
  { "dn" = "/C=DE/CN=Anne Anonymous" }
}
{ "#comment" = "the following are the user password records" }
{ "passwd" = "admin"
  { "pwdhash" = "b0da6de6" }
  { "access" = "read-write" }
  { "uid" = "600" }
  { "gid" = "600" }
  { "home" = "/" }
  { "root" = "/" }
}


test Kpwd.lns put conf after
  insa "login" "login[. = \"admin\"]";
  set "login[preceding-sibling::login = \"admin\"]" "boss";
  set "login[. = \"boss\"]/access" "read-write";
  set "login[. = \"boss\"]/uid" "1337";
  set "login[. = \"boss\"]/gid" "31337";
  set "login[. = \"boss\"]/home" "/";
  set "login[. = \"boss\"]/root" "/";
  set "login[. = \"boss\"]/dn[. = \"/C=DE/CN=Big Boss\"]" "/C=DE/CN=Big Boss";
  set "login[. = \"boss\"]/dn[. = \"/C=DE/CN=The Boss\"]" "/C=DE/CN=The Boss" =
"# Some comment
version 2.1
mapping \"/C=DE/CN=John Doe\" john
mapping \"/C=DE/CN=Michael Smith\" michael

# the following are the user auth records
login admin read-write 600 600 / / /
  /C=DE/CN=Susie Somebody
  /C=DE/CN=Anne Anonymous

login boss read-write 1337 31337 / /
  /C=DE/CN=Big Boss
  /C=DE/CN=The Boss

# the following are the user password records
passwd admin b0da6de6 read-write 600 600 / /
"
