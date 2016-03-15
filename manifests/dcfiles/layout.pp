define dcache::dcfiles::layout (
  $file,
  $augeas,
) {
  
  Augeas {
    lens => 'DCacheLayout.lns',
    incl => $file,
  }
  
  if has_key($augeas, 'properties') {
    validate_hash($augeas['properties'])
    # Attempt to update the bare properties first.
    augeas { "Update bare properties to '${file}'":
      name    => 'update_bare_properties',
      before  => Augeas['add_bare_properties'],
      changes => flatten([
        'defvar this properties',
        map($augeas['properties']) |$k, $v| { "set \$this/${k} '${v}'" },
      ]),
      onlyif  => 'match properties size == 1',
    }
    # Only add the bare properties in, if they don't exist yet.
    augeas { "Add bare properties to '${file}'":
      name    => 'add_bare_properties',
      changes => flatten([
        'insert properties before *[1]',
        map($augeas['properties']) |$k, $v| { "set properties/${k} '${v}'" }
      ]),
      onlyif  => 'match * size != 0',
    }
    # Insert fails, if the file is empty or doesn't exist yet..
    augeas { "Begin '${file}' with bare properties":
      name    => 'start_with_bare_properties',
      changes => map($augeas['properties']) |$k, $v| { "set properties/${k} '${v}'" },
      onlyif  => 'match * size == 0',
    }
  }
  
  each(filter($augeas) |$k, $v| {$k != 'properties'}) |$domain, $dhash| {
    validate_hash($dhash)
    # In order to guarantee the order of the changes applied by Augeas
    # and that different statements of different domains are not mixed
    # together, we have to prepare all the commands before the resource
    # is declared.
    
    if has_key($dhash, 'properties') {
      $dprops = [
        'defnode props $this/properties ""',
        'clear $props',
        map($dhash['properties']) |$k, $v| { "set \$props/${k} '${v}'" },
      ]
    } else {
      $dprops = []
    }
    
    if has_key($dhash, 'services') {
      # The list of services cannot be a hash, because that would disallow
      # having more than one instance of the same service in one domain
      # (e.g. no more than one pool per domain).
      validate_array($dhash['services'])
      # This is very ugly, but Puppet doesn't allow variables to be assigned
      # more often than exactly once, which invludes that neither arrays
      # nor hashes can be updated.
      $dservices = flatten(map($dhash['services']) |$i, $service| {
        # $service now either is a string or a hash. In the latter case,
        # some more properties are supplied.
        if is_hash($service) {
          # We're iterating over exactly one element here just because we
          # need to store the key.
          map($service) |$sk, $sv| {
            validate_hash($sv)
            # Since the "service" tree nodes in Augeas may have the very same
            # values, we cannot differentiate them properly anymore besides
            # their order of appearance.
            [
              "defnode service \$this/service[${$i+1}] '${domain}/${sk}'",
              'defnode props $service/properties ""',
              'clear $props',
              map($sv) |$k, $v| { "set \$props/${k} '${v}'" },
            ]
          }
        } else {
          "set \$this/service[. = '${domain}/${service}'] '${domain}/${service}'"
        }
      })
    } else {
      fail("Having domains (${domain}) without any services is illegal!")
    }
    
    augeas { "Add domain '${domain}' to '${file}'":
      name    => "augeas_create_${domain}",
      require => Augeas['start_with_bare_properties', 'add_bare_properties', 'update_bare_properties'],
      changes => flatten([
        "defnode this domain[. = '${domain}'] '${domain}'",
        $dprops,
        $dservices,
      ]),
    }
  }
}
