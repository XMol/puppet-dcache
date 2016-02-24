define dcache::dcfiles::poolmanager::pm_lgroup (
  $online = false,
  $nearline = false,
  $replica = false,
  $custodial = false,
  $output = false,
  $members = {},
) {
  $setup = $dcache::poolmanager
  
  augeas { "Create link group '${title}' in '${setup}'":
    name    => "augeas_create_${title}",
    changes => "set psu_create_linkGroup[. = '${title}'] '${title}'",
  }
  
  $allowances = {
    online    => $online,
    nearline  => $nearline,
    replica   => $replica,
    custodial => $custodial,
    output    => $output,
  }
  augeas { "Set allowances of link group '${title}' in '${setup}'":
    require => Augeas["augeas_create_${title}"],
    changes => flatten([
      map($allowances) |$key, $value| {[
        "defnode this psu_set_linkGroup_${key}[. = '${title}'] '${title}'",
        "set \$this/1 '${value}'",
      ]},
    ]),
  }

  validate_hash($members)
  if !empty($members) {
    create_resources('dcache::dcfiles::poolmanager::pm_link', $members)
    augeas { "Add members to link group '${title}' in '${setup}'":
      require => Augeas["augeas_create_${title}"],
      changes => flatten([
        map($members) |$link| {[
          "defnode this psu_addto_linkGroup[. = '${title}' and ./1 = '${link}'] '${title}'",
          "set \$this/1 '${link}'",
        ]},
      ]),
    }
  }
}
