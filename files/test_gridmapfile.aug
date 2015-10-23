(* Put this file in /usr/share/augeas/lenses/tests
   It then may be used to verify the functionality of the lens
   gridmapfile.aug.
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
    { "fqan" = ""
      { "login" = "robot" }
    }
  }
  { "dn" = "*"
    { "fqan" = "/ops"
      { "login" = "ops" }
    }
  }
  { "dn" = "*"
    { "fqan" = "/ops/Role=admin"
      { "login" = "admin" }
    }
  }
