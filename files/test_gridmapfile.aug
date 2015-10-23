(* This test only serves as an example for how configuration files will be
   transformed into trees by Augeas, since the actual lens doesn't pass
   testing by augparse.
*)

module Test_gridmapfile =

let conf ="# Some comment
\"/C=DE/OU=KIT/CN=HAL9000 (Robot)\" \"\" robot
* \"/ops\" ops
* \"/ops/Role=admin\" admin
"


test GridMapFile.lns get conf =
  { "#comment" = "Some comment" }
  { "dn" = "/C=DE/OU=KIT/CN=HAL9000 (Robot)"
    { "fqan" = "" }
    { "login" = "robot" }
  }
  { "dn" = "*"
    { "fqan" = "/ops" }
    { "login" = "ops" }
  }
  { "dn" = "*"
    { "fqan" = "/ops/Role=admin" }
    { "login" = "admin" }
  }
