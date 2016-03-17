define dcache::dcfiles::kpwd (
  $file,
  $augeas,
) {
  validate_hash($augeas)
  
  Augeas {
    lens => 'Kpwd.lns', # Coming with this module.
    incl => $file,
  }
  
  if !has_key($augeas, 'version') {
    fail('Kpwd requires a version setting!')
  } else {
    augeas { "Set version in '${file}'":
      changes => "set version ${augeas['version']}",
    }
  }
  
  if has_key($augeas, 'mappings') {
    validate_hash($augeas['mappings'])
    augeas { "Add mappings to '${file}'":
      changes => flatten(map($augeas['mappings']) |$dn, $login| {[
        "defnode this mapping[. = '${login}' and dn = '${dn}'] '${login}'",
        "set \$this/dn '${dn}'",
      ]}),
    }
  }
  
  if has_key($augeas, 'logins') {
    validate_hash($augeas['logins'])
    create_resources('dcache::dcfiles::kpwd_login', $augeas['logins'])
  }
  
  if has_key($augeas, 'passwds') {
    validate_hash($augeas['passwds'])
    create_resources('dcache::dcfiles::kpwd_passwd', $augeas['passwds'])
  }
}