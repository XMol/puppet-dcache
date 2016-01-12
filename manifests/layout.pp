# Generate the layout file for a host.
# The layout file will be managed by Augeas. We will only ever change one
# specific file with a custom lens (which is autoloaded).
define dcache::layout (
  $layout,
  $layout_file = "$dcache::dcache_layout_file",
) {
  require dcache::augeas
  
  Augeas {
    lens => 'DCacheLayout.lns',
    incl => "$layout_file",
  }
  
  if has_key($layout, 'properties') {
    validate_hash($layout['properties'])
    augeas { "Add bare properties to '$layout_file'":
      changes => flatten([
        "defnode this properties",
        map($layout['properties']) |$k, $v| { "set \$this/$k \"$v\"" },
      ]),
    }
  }
  
  if has_key($layout, 'domains') {
    validate_hash($layout['domains'])
    each($layout['domains']) |$domain, $dhash| {
      validate_hash($dhash)
      augeas { "Add domain '$domain' to '$layout_file'":
        name => "augeas_create_$domain",
        changes => "set domain[. = \"$domain\"] \"$domain\"",
      }
      
      if has_key($dhash, 'properties') {
        augeas { "Add properties to domain '$domain' in '$layout_file'":
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
        # (which would be rare, but nevertheless is supported by dCache).
        validate_array($dhash['services'])
        each($dhash['services']) |$service| {
          # $service now either is a string or a hash. In the latter case,
          # some more properties are supplied, with need to be written to
          # the layout file.
          if is_hash($service) {
            # We're iterating over exactly one element here just because we
            # need to store the key.
            each($service) |$sk, $sv| {
              validate_hash($sv)
              augeas { "Add '$domain/$sk' to '$layout_file'":
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
            augeas { "Add '$domain/$service' to '$layout_file'":
              require => Augeas["augeas_create_$domain"],
              changes =>
                "set domain[. = \"$domain\" and service = \"$domain/$service\"]/service \"$domain/$service\"",
            }
          }
        }
      }
    }
  }
}