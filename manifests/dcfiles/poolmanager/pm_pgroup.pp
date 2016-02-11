define dcache::dcfiles::poolmanager::pm_pgroup (
  $pools,
) {
  $setup = $dcache::poolmanager
  validate_array($pools)
  
  $h = hash(flatten(map($pools) |$p| {
               if is_hash($p) { 
                 [ keys($p)[0], { 'attr' => values($p)[0] } ]
               } elsif is_string($p) { [ $p, { 'attr' => [] } ] }
               else { fail("Illegal pool object ('$p')!") }
             }))
  create_resources('dcache::dcfiles::poolmanager::pm_pool', $h)
  
  augeas { "Create pgroup '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => "set psu_create_pgroup[. = \"$title\"] \"$title\"",
  }

  augeas { "Add pools to pgroup '$title' in '$setup'":
    require => Augeas["augeas_create_$title"],
    changes => flatten(map($pools) |$pool| {[
      if is_hash($pool) {
        with(keys($pool)[0]) |$p| {[
          "defnode this psu_addto_pgroup[. = '$title' and ./1 = '$p'] '$title'",
          "set \$this/1 '$p'"
        ]}
      } else {[
        "defnode this psu_addto_pgroup[. = '$title' and ./1 = '$pool'] '$title'",
        "set \$this/1 '$pool'"
      ]}
    ]}),
  }
}
