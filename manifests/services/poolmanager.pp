define dcache::services::poolmanager (
  $properties = {},
  $setup = $dcache::poolmanager_conf,
  $content = undef,
  $source = undef,
  $augeas = undef,
) {
  File { 
    path => "$setup",
    owner => "$dcache::dcache_user",
    group => "$dcache::dcache_group",
  }
  
  Augeas {
    incl => "$setup",
    lens => "PoolManager.lns", # Lens installed with this Puppet module.
  }
  
  if $content {
    # Only act for one of the parameters and fail if more are set.
    if $source or $augeas {
      fail('Only one out of $content, $source or $augeas may be set!')
    }
    validate_string($content)
    file { "Set content of '$setup'":
      content => "$content",
    }
  } 
  
  elsif $source {
    if $augeas {
      fail('Only one out of $content, $source or $augeas may be set!\n')
    }
    file { "Source '$setup'":
      source => "$source",
    }
  }
  
  elsif $augeas {
    validate_hash($augeas)
    each($augeas) |$class, $collection| {
      validate_hash($collection)
      case "$class" {
        'units': {
          validate_hash($collection)
          ensure_resource('dcache::services::poolmanager::pm_units',
                          $collection, {})
        }
        'ugroups': {
          validate_hash($collection)
          create_resources('dcache::services::poolmanager::pm_ugroup',
                           $collection)
        }
        'pools': {
          # $collection here should be a list of either strings or hashes.
          # A string represents the pool's name, whereas a hash contains
          # some further data for the pool.
          validate_array($collection)
          each($collection) |$element| {
            if is_hash($element) {
              create_resources('dcache::services::poolmanager::pm_pool',
                               $element)
            } else {
              ensure_resource('dcache::services::poolmanager::pm_pool',
                              $element, {})
            }
          }
        }
        'pgroups': {
          each($collection) |$pgroup, $pools| {
            ensure_resource('dcache::services::poolmanager::pm_pgroup',
                            $pgroup, { 'pools' => $pools })
          }
        }
        'links': {
          create_resources('dcache::services::poolmanager::pm_link',
                           $collection)
        }
        'linkgroups': {
          create_resources('dcache::services::poolmanager::pm_lgroup',
                           $collection)
        }
        'rc': {
          augeas { "Manage recalls module settings in '$setup'":
            changes => map($collection) |$key, $value| {
              "set rc_set_$key $value"
            },
          }
        }
        'pm': {
          each($collection) |$pm, $settings| {
            validate_hash($settings)
            augeas { "Manage partition '$pm' in '$setup'":
              name => "augeas_create_$pm",
              changes => flatten([
                "set pm_create[. = \"$pm\"] \"$pm\"",
                "defnode this pm_set[. = \"$pm\"]",
                "set \$this \"$pm\"",
                map(filter($settings) |$k, $v| { $k != 'type' }) |$key, $value| {
                  "set \$this/$key \"$value\""
                }
              ]),
            }
            if has_key($settings, 'type') {
              augeas { "Set type of partition '$pm' in '$setup'":
                require => Augeas["augeas_create_$pm"],
                changes => "set pm/create[. = \"$pm\"]/type ${settings['type']}",
              }
            }
          }
        }
        'cm': {
          augeas { "Manage cost module settings in '$setup'":
            changes => map($collection) |$key, $value| {
              "set cm_$key $value"
            },
          }
        }
      }
    }
  } else {
    fail('None of $content, $source or $augeas are set!\n')
  }
}