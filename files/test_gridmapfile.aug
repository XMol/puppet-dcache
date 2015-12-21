(* This test only serves as an example for how configuration files will be
   transformed into trees by Augeas, since the actual lens doesn't pass
   testing by augparse.
*)

module Test_gridmapfile =

let conf =
"# Most common VOMS matching rule.
* /vo vo001
* /vo/Role:admin voadmin

# Matching specific DNs.
\"/C=DE/OU=KIT/CN=HAL9000 (Robot)\" robot

# Overruling
\"/C=DE/OU=KIT/CN=John Doe\" \"\" jonny
\"/C=DE/OU=KIT/CN=John Doe\" /org/Role:manager john
\"/C=DE/OU=KIT/CN=John Doe\" \"/org/Role:top tear investor\" boss
"


test GridMapFile.lns get conf =
{ "#comment" = "Most common VOMS matching rule." }
{ "mapping"
  { "dn" = "*" }
  { "fqan" = "/vo" }
  { "login" = "vo001" }
}
{ "mapping"
  { "dn" = "*" }
  { "fqan" = "/vo/Role:admin" }
  { "login" = "voadmin" }
}
{ }
{ "#comment" = "Matching specific DNs." }
{ "mapping"
  { "dn" = "/C=DE/OU=KIT/CN=HAL9000 (Robot)" }
  { "login" = "robot" }
}
{ }
{ "#comment" = "Overruling" }
{ "mapping"
  { "dn" = "/C=DE/OU=KIT/CN=John Doe" }
  { "fqan" = "\"\"" }
  { "login" = "jonny" }
}
{ "mapping"
  { "dn" = "/C=DE/OU=KIT/CN=John Doe" }
  { "fqan" = "/org/Role:manager" }
  { "login" = "john" }
}
{ "mapping"
  { "dn" = "/C=DE/OU=KIT/CN=John Doe" }
  { "fqan" = "/org/Role:top tear investor" }
  { "login" = "boss" }
}

test GridMapFile.lns put conf after
    set "mapping[login = \"robot\"]/login" "hal" =
"# Most common VOMS matching rule.
* /vo vo001
* /vo/Role:admin voadmin

# Matching specific DNs.
\"/C=DE/OU=KIT/CN=HAL9000 (Robot)\" hal

# Overruling
\"/C=DE/OU=KIT/CN=John Doe\" \"\" jonny
\"/C=DE/OU=KIT/CN=John Doe\" /org/Role:manager john
\"/C=DE/OU=KIT/CN=John Doe\" \"/org/Role:top tear investor\" boss
"
