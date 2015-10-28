(* Put this file into /usr/share/augeas/lenses/tests, then one may test
   the functionality of the Kpwd augeas module.
*)

module Test_kpwd =

let conf ="# Some comment
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
    { "secureids"
      { "1" = "/C=DE/CN=Susie Somebody" }
      { "2" = "/C=DE/CN=Anne Anonymous"}
    }
    {}
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
