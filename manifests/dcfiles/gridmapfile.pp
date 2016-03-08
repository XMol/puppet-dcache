define dcache::dcfiles::gridmapfile (
  $file,
  $augeas,
) {
  validate_array($augeas)
  
  Augeas {
    lens => 'GridMapFile.lns', # Coming with this module.
    incl => $file,
  }
  
  augeas { "Manage '${file}'":
    changes => flatten(map($augeas) |$mapping| {
      if has_key($mapping, 'fqan') {[
        "defnode this mapping[dn = '${mapping[dn]}' and fqan = '${mapping[fqan]}'] '${mapping[login]}'",
        "set \$this/dn '${mapping[dn]}'",
        "set \$this/fqan '${mapping[fqan]}'",
      ]} else {[
        "defnode this mapping[dn = '${mapping[dn]}'] '${mapping[login]}'",
        "set \$this/dn '${mapping[dn]}'",
      ]}
    }),
  }
}
