define dcache::dcfiles::poolmanager::pm_ugroup (
  $units,
) {
  $setup = $dcache::poolmanager
  
  validate_hash($units)
  
  ensure_resource('dcache::dcfiles::poolmanager::pm_units',
                  "The PoolManager units of ugroup '$title'",
                  $units)
  augeas { "Manage ugroup '$title' in '$setup'":
    changes => flatten([
      "set psu_create_ugroup[. = \"$title\"] \"$title\"",
      map(keys($units)) |$unit| {[
        "defnode this psu_addto_ugroup[. = \"$title\" and ./1 = \"$unit\"] \"$title\"",
        "set \$this/1 \"$unit\"",
      ]},
    ]),
  }
  
}