define dcache::services::poolmanager::pm_pgroup (
  $pools,
) {
  $setup = $dcache::poolmanager_conf

  augeas { "Create pgroup '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => "set psu_create_pgroup[. = \"$title\"] \"$title\"",
  }

  validate_array($pools)
  augeas { "Add pools to pgroup '$title' in '$setup'":
    require => [ Augeas["augeas_create_$title"],
                 Dcache::Services::Poolmanager::Pm_pool <| |>,
               ],
    changes => flatten(map($pools) |$pool| {[
      "defnode this psu_addto_pgroup[. = \"$title\" and ./1 = \"$pool\"]",
      "set \$this \"$title\"",
      "set \$this/1 \"$pool\"",
    ]}),
  }
}