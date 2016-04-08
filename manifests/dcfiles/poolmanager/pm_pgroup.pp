define dcache::dcfiles::poolmanager::pm_pgroup (
  $pools,
) {
  $setup = $dcache::poolmanager
  
  augeas { "Create pgroup '${title}' in '${setup}'":
    name    => "augeas_create_${title}",
    changes => "set psu_create_pgroup[. = '${title}'] '${title}'",
  } ->
  augeas { "Add pools to pgroup '${title}' in '${setup}'":
    changes => flatten(map($pools) |$pool| {[
      "defnode this psu_addto_pgroup[. = '${title}' and ./1 = '${pool}'] '${title}'",
      "set \$this/1 '${pool}'"
    ]}),
  }
}
