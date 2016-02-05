define dcache::dcfiles::poolmanager::pm_link (
  $ugroups,
  $prefs = {},
  $members = {},
) {
  $setup = $dcache::poolmanager

  validate_hash($ugroups)
  create_resources('dcache::dcfiles::poolmanager::pm_ugroup',
                   hash(flatten(map($ugroups) |$ugroup, $units| {
                     [ $ugroup, { 'units' => $units } ]
                   })))

  augeas { "Create link '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => flatten([
      "defnode this psu_create_link[. = \"$title\"] \"$title\"",
      map($ugroups) |$ug| {
      "set \$this/ugroup[. = \"$ug\"] \"$ug\""
      },
    ]),
  }
  
  validate_hash($prefs)
  if !empty($prefs) {
    augeas { "Manage preferences on '$title' in '$setup'":
      require => Augeas["augeas_create_$title"],
      changes => flatten([
        "defnode this psu_set_link[. = \"$title\"] \"$title\"",
        map($prefs) |$key, $value| {
          "set \$this/$key \"$value\""
        }
      ]),
    }
  }
  
  validate_hash($members)
  if !empty($members) {
    $h = hash(flatten(map($members) |$pgroup, $pools| {
           if is_array($pools) { [ $pgroup, { 'pools' => $pools } ] }
           else { fail("Pool group '$pgroup' does not map to an array!") }
         }))
    create_resources('dcache::dcfiles::poolmanager::pm_pgroup', $h)
    map($members) |$member| {
      augeas { "Add member '$member' to link '$title' in '$setup'":
        require => Augeas["augeas_create_$title"],
        changes => [
          "defnode this psu_addto_link[. = \"$title\" and ./1 = \"$member\"] \"$title\"",
          "set \$this/1 \"$member\"",
        ]
      }
    }
  }
}