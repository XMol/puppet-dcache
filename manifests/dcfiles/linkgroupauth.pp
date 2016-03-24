define dcache::dcfiles::linkgroupauth (
  $file,
  $augeas,
) {
  
  Augeas {
    lens => 'LinkGroupAuthorization.lns', # Coming with this module.
    incl => $file,
  }
  
  each($augeas) |$lgroup, $entries| {
    validate_array($entries)
    augeas { "Manage '${lgroup}' in '${file}'":
      changes => flatten([
        "defnode this LinkGroup[. = '${lgroup}'] '${lgroup}'",
        map($entries) |$entry| {
          "set \$this/entry[. = '${entry}'] '${entry}'"
        },
      ]),
    }
  }
}
