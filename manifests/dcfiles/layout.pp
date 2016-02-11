define dcache::dcfiles::layout (
  $file,
  $augeas,
) {
  
  Augeas {
    lens => 'DCacheLayout.lns',
    incl => "$file",
  }
  
  if has_key($augeas, 'properties') {
    validate_hash($augeas['properties'])
    augeas { "Add bare properties to '$file'":
      name => "augeas_layout_properties",
      changes => flatten([
        "defnode this properties \"\"",
        # Puppet applying Augeas is broken in that defnode requires a third
        # parameter, but our lens doesn't expect one. Thus we have to
        # remove it again.
        "clear \$this",
        map($augeas['properties']) |$k, $v| { "set \$this/$k \"$v\"" },
      ]),
    }
  }
  
  each(filter($augeas) |$k, $v| {$k != 'properties'}) |$domain, $dhash| {
    validate_hash($dhash)
    augeas { "Add domain '$domain' to '$file'":
      name => "augeas_create_$domain",
      require => "augeas_layout_properties",
      changes => "set domain[. = \"$domain\"] \"$domain\"",
    }
    
    if has_key($dhash, 'properties') {
      augeas { "Add properties to domain '$domain' in '$file'":
        require => Augeas["augeas_create_$domain"],
        changes => flatten([
          "defnode this domain[. = \"$domain\"]/properties",
          map($dhash['properties']) |$k, $v| { "set \$this/$k \"$v\"" }
        ]),
      }
    }
    
    if has_key($dhash, 'services') {
      # The list of services cannot be a hash, because that would disallow
      # having more than one instance of the same service in one domain
      # (e.g. no more than one pool per domain).
      validate_array($dhash['services'])
      each($dhash['services']) |$index, $service| {
        # $service now either is a string or a hash. In the latter case,
        # some more properties are supplied.
        if is_hash($service) {
          # We're iterating over exactly one element here just because we
          # need to store the key.
          each($service) |$sk, $sv| {
            validate_hash($sv)
            augeas { "Add '$domain/$sk($index)' to '$file'":
              require => Augeas["augeas_create_$domain"],
              changes => flatten([
                "defnode this domain[. = \"$domain\" and service = \"$domain/$sk\"]/service",
                "set \$this \"$domain/$sk\"",
                "defnode this \$this/properties",
                map($sk) |$k, $v| { "set \$this/$k \"$v\"" },
              ]),
            }
          }
        } else {
          # $service is a bare string, no further properties to add to the
          # layout file.
          augeas { "Add '$domain/$service' to '$file'":
            require => Augeas["augeas_create_$domain"],
            changes =>
              "set domain[. = \"$domain\" and service = \"$domain/$service\"]/service \"$domain/$service\"",
          }
        }
      }
    }
  }
}
