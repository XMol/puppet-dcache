define dcache::dcfiles::poolmanager::pm_ugroup (
  $units,
) {
  $setup = $dcache::poolmanager
  
  validate_array($units)
  
  ensure_resource('dcache::dcfiles::poolmanager::pm_units',
                  "The PoolManager units of ugroup '$title'",
                  $units)
  augeas { "Manage ugroup '$title' in '$setup'":
    require => Dcache::Dcfiles::Poolmanager::Pm_units <| |>,
    changes => flatten([
      "defnode this psu_create_ugroup[. = \"$title\"]",
      "set \$this \"$title\"",
      "set \$this/type \"$type\"",
      map($units) |$unit| {[
        "defnode this psu_addto_ugroup[. = \"$title\" and ./1 = \"$unit\"]",
        "set \$this \"$title\"",
        "set \$this/1 \"$unit\"",
      ]},
    ]),
  }
  
}