define dcache::services::poolmanager::pm_ugroup (
  $type,
  $units,
) {
  $setup = $dcache::poolmanager_conf
  
  validate_array($units)
  
  augeas { "Manage ugroup '$title' in '$setup'":
    require => Dcache::Services::Poolmanager::Pm_units <| |>,
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