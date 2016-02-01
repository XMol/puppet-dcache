define dcache::dcfiles::poolmanager::pm_pgroup (
  $pools,
) {
  $setup = $dcache::poolmanager
  validate_array($pools)
  
  create_resources('dcache::dcfiles::poolmanager::pm_pool',
                   hash(flatten(map($pools) |$p| {
                     if is_hash($p) { any2array($p) }
                     elsif is_string($p) { [ $p, [] ] }
                     else { fail("Illegal pool object ('$p')!") }
                   })))
  
  augeas { "Create pgroup '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => "set psu_create_pgroup[. = \"$title\"] \"$title\"",
  }

  augeas { "Add pools to pgroup '$title' in '$setup'":
    require => [ Augeas["augeas_create_$title"],
                 Dcache::Dcfiles::Poolmanager::Pm_pool <| |>,
               ],
    changes => flatten(map($pools) |$pool| {[
      "defnode this psu_addto_pgroup[. = \"$title\" and ./1 = \"$pool\"]",
      "set \$this \"$title\"",
      "set \$this/1 \"$pool\"",
    ]}),
  }
}