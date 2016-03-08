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
{ "mapping" = "vo001"
  { "dn" = "*" }
  { "fqan" = "/vo" }
}
{ "mapping" = "voadmin"
  { "dn" = "*" }
  { "fqan" = "/vo/Role:admin" }
}
{ }
{ "#comment" = "Matching specific DNs." }
{ "mapping" = "robot"
  { "dn" = "/C=DE/OU=KIT/CN=HAL9000 (Robot)" }
}
{ }
{ "#comment" = "Overruling" }
{ "mapping" = "jonny"
  { "dn" = "/C=DE/OU=KIT/CN=John Doe" }
  { "fqan" = "\"\"" }
}
{ "mapping" = "john"
  { "dn" = "/C=DE/OU=KIT/CN=John Doe" }
  { "fqan" = "/org/Role:manager" }
}
{ "mapping" = "boss"
  { "dn" = "/C=DE/OU=KIT/CN=John Doe" }
  { "fqan" = "/org/Role:top tear investor" }
}

test GridMapFile.lns put conf after
    set "mapping[. = \"robot\"]" "hal" =
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
