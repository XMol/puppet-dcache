define dcache::dcfiles::gridmapfile (
  $file,
  $augeas,
) {
  if !has_key($augeas, 'mappings') {
    fail('The gridmap/vorolemap Augeas information has to have a key "mappings"!')
  }

  validate_array($augeas['mappings'])
  
  Augeas {
    lens => 'GridMapFile.lns', # Coming with this module.
    incl => $file,
  }
  
  augeas { "Manage '${file}'":
    changes => flatten(map($augeas['mappings']) |$mapping| {
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
