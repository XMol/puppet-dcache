define dcache::dcfiles::poolmanager::pm_ugroup (
  $units = [],
) {
  $setup = $dcache::poolmanager
  
  augeas { "Create ugroup '${title}' in '${setup}'":
    changes => flatten([
      "set psu_create_ugroup[. = '${title}'] '${title}'",
      map($units) |$unit| {[
        "defnode this psu_addto_ugroup[. = '${title}' and ./1 = '${unit}'] '${title}'",
        "set \$this/1 '${unit}'",
      ]},
    ]),
  }
  
}
