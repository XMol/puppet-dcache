define dcache::dcfiles::authzdb (
  $file,
  $augeas,
) {
  
  Augeas {
    lens => 'StorageAuthzdb.lns', # Coming with this module.
    incl => $file,
  }
  
  if !has_key($augeas, 'version') {
    fail('Authzdb requires a version setting!')
  }
  
  augeas { "Set version of authzdb in '${file}'":
    changes => "set version ${augeas['version']}",
  }
  create_resources('dcache::dcfiles::authzb_rule', delete($augeas, 'version'))
}
