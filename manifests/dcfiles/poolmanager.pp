define dcache::dcfiles::poolmanager (
  $file,
  $augeas,
) {
  
  Augeas {
    lens => 'PoolManager.lns', # Lens installed with this Puppet module.
    incl => $file,
  }
  
  each($augeas) |$class, $collection| {
    case $class {
      'units': {
        validate_hash($collection)
        create_resources('dcache::dcfiles::poolmanager::pm_units', {'The PoolManager units' => $collection})
      }
      'ugroups': {
        validate_hash($collection)
        $h = hash(flatten(map($collection) |$ugroup, $units| { [ $ugroup, { 'units' => $units } ] }))
        create_resources('dcache::dcfiles::poolmanager::pm_ugroup', $h)
      }
      'pools': {
        # $collection here should be a list of strings and hashes.
        # A string represents the pool's name, whereas a hash contains
        # some further data for the pool. Replace all strings with a
        # hash (with that string as its only key), so we can iterate
        # with create_resources.
        validate_array($collection)
        $h =
          hash(flatten(map($collection) |$c| {
            if is_hash($c) {
              [ keys($c)[0], { 'attr' => values($c)[0] } ]
            } elsif is_string($c) { [ $c, { 'attr' => [] } ] }
            else { fail("Illegal pool object ('${c}')!") }
          }))
        create_resources('dcache::dcfiles::poolmanager::pm_pool', $h)
      }
      'pgroups': {
        validate_hash($collection)
        # $collection is already a hash with all pgroups as keys and the
        # list of member pools as an array. Though for iteration with
        # create_resources we need a slightly different format.
        $h =
          hash(flatten(map($collection) |$pgroup, $pools| {
            if is_array($pools) { [ $pgroup, { 'pools' => $pools } ] }
            else { fail("Pool group '${pgroup}' does not map to an array!") }
          }))
        create_resources('dcache::dcfiles::poolmanager::pm_pgroup', $h)
      }
      'links': {
        validate_hash($collection)
        create_resources('dcache::dcfiles::poolmanager::pm_link', $collection)
      }
      'lgroups': {
        validate_hash($collection)
        create_resources('dcache::dcfiles::poolmanager::pm_lgroup', $collection)
      }
      'rc': {
        validate_hash($collection)
        augeas { "Manage recalls module settings in '${file}'":
          changes => map($collection) |$key, $value| {
            "set rc_set_${key} ${value}"
          },
        }
      }
      'pm': {
        each($collection) |$pm, $settings| {
          validate_hash($settings)
          augeas { "Manage partition '${pm}' in '${file}'":
            name    => "augeas_create_${pm}",
            changes => flatten([
              "set pm_create[. = '${pm}'] '${pm}'",
              "defnode this pm_set[. = '${pm}'] '${pm}'",
              map(filter($settings) |$k, $v| { $k != 'type' }) |$key, $value| {
                "set \$this/${key} '${value}'"
              }
            ]),
          }
          if has_key($settings, 'type') {
            augeas { "Set type of partition '${pm}' in '${file}'":
              require => Augeas["augeas_create_${pm}"],
              changes => "set pm_create[. = '${pm}']/type ${settings['type']}",
            }
          }
        }
      }
      'cm': {
        validate_hash($collection)
        augeas { "Manage cost module settings in '${file}'":
          changes => map($collection) |$key, $value| {
            "set cm_${key} ${value}"
          },
        }
      }
      default: {
        fail("Unmatched PoolManager class ('${class}')!")
      }
    }
  }
}
