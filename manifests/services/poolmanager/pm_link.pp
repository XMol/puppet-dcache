define dcache::services::poolmanager::pm_link (
  $units,
  $prefs,
  $members,
) {
  $setup = $dcache::poolmanager_conf

  validate_array($units)
  augeas { "Create link '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => flatten([
      "defnode this psu_create_link[. = \"$title\"]",
      "set \$this \"$title\"",
      map($units) |$unit| {
      "set \$this/ugroup[. = \"$unit\"] \"$unit\""
      },
    ]),
  }
  
  validate_hash($prefs)
  augeas { "Manage preferences on '$title' in '$setup'":
    require => Augeas["augeas_create_$title"],
    changes => flatten([
      "defnode this psu_set_link[. = \"$title\"]",
      "set \$this \"$title\"",
      map($prefs) |$key, $value| {
        "set \$this/$key \"$value\""
      }
    ]),
  }
  
  validate_array($members)
  map($members) |$member| {
    augeas { "Add member '$member' to link '$title' in '$setup'":
      require => [ Augeas["augeas_create_$title"],
                   Dcache::Services::Poolmanager::Pm_pgroup <| |>,
                 ],
      changes => [
        "defnode this psu_addto_link[. = \"$title\" and ./1 = \"$member\"]",
        "set \$this \"$title\"",
        "set \$this/1 \"$member\"",
      ]
    }
  }
}
}