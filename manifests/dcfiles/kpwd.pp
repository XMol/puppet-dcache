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
    validate_array($augeas['logins']['dns'])
    augeas { "Add logins to '${file}'":
      name    => 'augeas_logins_kpwd',
      changes => flatten(map($augeas['logins']) |$login, $creds| {[
        "defnode this login[. = '${login}'] '${login}'",
        "set \$this/access '${creds[access]}'",
        "set \$this/uid '${creds[uid]}'",
        "set \$this/gid '${creds[gid]}'",
        "set \$this/home '${creds[home]}'",
        "set \$this/root '${creds[root]}'",
        map($creads[dns]) |$dn| { "defnode \$this/dn[. = '${dn}'] '${dn}'" },
      ]}),
    }
    
    $extraloginfs = filter($augeas['logins']) |$login, $creds| { has_key($creds, 'fsroot') }
    if !empty($extraloginfs) {
      augeas { "Add optional file system roots to logins in '${file}'":
        require => Augeas['augeas_logins_kpwd'],
        changes => flatten(map($extraloginfs) |$login, $creds| {[
          "ins fsroot after login[. = '${login}']/root",
          "set login[. = '${login}']/fsroot '${creds[fsroot]}'",
        ]}),
      }
    }
  }
  
  if has_key($augeas, 'passwds') {
    validate_hash($augeas['passwds'])
    augeas { "Add passwd records to '${file}'":
      name    => 'augeas_pwd_kpwd',
      changes => flatten(map($augeas['passwds']) |$login, $creds| {[
        "defnode this passwd[. = '${login}'] '${login}'",
        "set \$this/pwdhash '${creds[pwdhash]}'",
        "set \$this/access '${creds[access]}'",
        "set \$this/uid '${creds[uid]}'",
        "set \$this/gid '${creds[gid]}'",
        "set \$this/home '${creds[home]}'",
        "set \$this/root '${creds[root]}'",
      ]}),
    }
    
    $extrapwdfs = filter($augeas['passwds']) |$login, $creds| { has_key($creds, 'fsroot') }
    if !empty($extrapwdfs) {
      augeas { "Add optional file system roots to passwd records in '${file}'":
        require => Augeas['augeas_pwd_kpwd'],
        changes => flatten(map($extrapwdfs) |$login, $creds| {[
          "ins fsroot after passwd[. = '${login}']/root",
          "set passwd[. = '${login}']/fsroot '${creds[fsroot]}'",
        ]}),
      }
    }
  }
}