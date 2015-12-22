define dcache::gplazma::gridmap (
  $kpwd_file = "$dcache::kpwd_file",
  $content = undef,
  $source = undef,
  $augeas = undef,
) {
  File { 
    path => "$kpwd_file",
    owner => "$dcache::dcache_user",
    group => "$dcache::dcache_group",
  }
  
  Augeas {
    incl => "$kpwd_file",
    lens => "Kpwd.lns", # Lens installed with this Puppet module.
  }
  
  if $content {
    # Only act for one of the parameters and fail if more are set.
    if $source or $augeas {
      fail('Only one out of $content, $source or $augeas may be set!')
    }
    validate_string($content)
    file { "Set content of '$kpwd_file'":
      content => "$content",
    }
  } 
  
  elsif $source {
    if $augeas {
      fail('Only one out of $content, $source or $augeas may be set!\n')
    }
    file { "Source '$kpwd_file'":
      source => "$source",
    }
  }
  
  elsif $augeas {
    validate_hash($augeas)
    unless has_key($augeas, 'version') {
      fail('When configuring dCache\'s kpwd file with Augeas, a "version" must be provided!')
    } else {
      augeas { "Manage kpwd's version":
        changes => "set version \"${augeas['version']}\"",
      }
    }
    each($augeas) |$key, $array| {
      validate_array($array)
      # Depending on $key we have to evaluate $hash differently.
      case "$key" {
        # $array is a list of mapping hashes.
        'mappings': {
          each($array) |$index, $hash| {
            validate_hash($hash)
            augeas { "Manage mapping '${hash['user']}' in $kpwd_file":
              changes => [
                "defnode this mapping[dn = \"${hash['dn']}\"]",
                "set \$this \"${hash['user']}\"",
                "set \$this/dn \"${hash['dn']}\"",
              ],
            }
          }
        }
        # $array is a list of login hashes.
        'logins': {
          each($array) |$index, $hash| {
            validate_hash($hash)
            augeas { "Manage login '${hash['user']}' in $kpwd_file":
              changes => [
                "defnode this login[. = \"${hash['user']}\"]",
                "set \$this \"${hash['user']}\"",
                "set \$this/access \"${hash['access']}\"",
                "set \$this/uid \"${hash['uid']}\"",
                "set \$this/gid \"${hash['gid']}\"",
                "set \$this/home \"${hash['home']}\"",
                "set \$this/root \"${hash['root']}\"",
                ],
            }
            
            if has_key($hash, 'fsroot') {
              augeas { "Add 'fsroot' for login '${hash['user']}'":
                changes => "ins \"fsroot\" after login[. = \"${hash['user']}\"]/root",
                onlyif => "match login[. = \"${hash['user']}\"]/fsroot size = 0",
              }
              augeas { "Set 'fsroot' for login '${hash['user']}'":
                changes => "set login[. = \"${hash['user']}\"]/fsroot \"${hash['fsroot']}\"",
              }
            }
            
            if has_key($hash, 'secureids') {
              validate_array($hash['secureids'])
              augeas { "Manage secure ids for login '${hash['user']}'":
                changes => flatten([
                  "defnode this login[. = \"${hash['user']}\"]",
                  map($hash['secureids']) |$id| {
                    "set \$this/dn[. = \"$id\"] \"$id\""
                  },
                ]),
              }
            }
          }
        }
        # $array is a list of password-based-login hashes.
        'passwds': {
          validate_array($array)
          each($array) |$index, $hash| {
            validate_hash($hash)
            augeas { "Manage password access by '${hash['user']}' in $kpwd_file":
              changes => [
                "defnode this passwd[. = \"${hash['user']}\"]",
                "set \$this \"${hash['user']}\"",
                "set \$this/pwdhash \"${hash['pwdhash']}\"",
                "set \$this/access \"${hash['access']}\"",
                "set \$this/uid \"${hash['uid']}\"",
                "set \$this/gid \"${hash['gid']}\"",
                "set \$this/home \"${hash['home']}\"",
                "set \$this/root \"${hash['root']}\"",
                ],
            }
            
            if has_key($hash, 'fsroot') {
              augeas { "Set 'fsroot' for password access by '${hash['user']}'":
                changes => "set passwd[. = \"${hash['user']}\"]/fsroot \"${hash['fsroot']}\"",
              }
            }
          }
        }
      }
    }
  } else {
    fail("At least one of the parameters for the gridmap resource must be set!")
  }
}
