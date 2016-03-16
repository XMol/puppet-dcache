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
    # This will create a illformatted file, in case there are already domains
    # defined and no bare properties. Puppet cannot check whether there is
    # a 'properties' node at first place in the file.
    augeas { "Update bare properties to '${file}'":
      name    => 'update_bare_properties',
      changes => map($augeas['properties']) |$k, $v| {
        "set properties/${k} '${v}'"
      },
    }
  }
  
  each(filter($augeas) |$k, $v| {$k != 'properties'}) |$domain, $dhash| {
    validate_hash($dhash)
    # In order to guarantee the order of the changes applied by Augeas
    # and that different statements of different domains are not mixed
    # together, we have to prepare all the commands before the resource
    # is declared.
    
    if has_key($dhash, 'properties') {
      $dprops = map($dhash['properties']) |$k, $v| {
        "set \$this/properties/${k} '${v}'"
      }
    } else {
      $dprops = []
    }
    
    if has_key($dhash, 'services') {
      # The list of services cannot be a hash, because that would disallow
      # having more than one instance of the same service in one domain
      # (e.g. no more than one pool per domain).
      validate_array($dhash['services'])
      # This is very ugly, but Puppet doesn't allow variables to be assigned
      # more often than exactly once, which includes that neither arrays
      # nor hashes can be updated.
      $dservices = map($dhash['services']) |$service| {
        # $service now either is a string or a hash. In the latter case,
        # some more properties are supplied.
        if is_hash($service) {
          map($service) |$sname, $sprops| {[
            "defnode service \$this/service[. = '${domain}/${sname}'] '${domain}/${sname}'",
            map($sprops) |$pk, $pv| { "set \$service/properties/${pk} '${pv}'" },
          ]}
        } else {
          "set \$this/service[. = '${domain}/${service}'] '${domain}/${service}'"
        }
      }
    } else {
      fail("Having domains (${domain}) without any services is illegal!")
    }
    
    augeas { "Add domain '${domain}' to '${file}'":
      require => Augeas['update_bare_properties'],
      changes => flatten([
        "defnode this domain[. = '${domain}'] '${domain}'",
        $dprops,
        $dservices,
      ]),
    }
  }
}
