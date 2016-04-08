define dcache::dcfiles::poolmanager::pm_lgroup (
  $allowances = {},
  $links = {},
) {
  $setup = $dcache::poolmanager
  
  augeas { "Create link group '${title}' in '${setup}'":
    name    => "augeas_create_${title}",
    changes => "set psu_create_linkGroup[. = '${title}'] '${title}'",
  }
  
  augeas { "Set allowances of link group '${title}' in '${setup}'":
    changes => flatten(map($allowances) |$key, $value| {[
      "defnode this psu_set_linkGroup_${key}[. = '${title}'] '${title}'",
      "set \$this/1 '${value}'",
    ]}),
  }

  augeas { "Add links to link group '${title}' in '${setup}'":
    changes => flatten(map($links) |$link| {[
      "defnode this psu_addto_linkGroup[. = '${title}' and ./1 = '${link}'] '${title}'",
      "set \$this/1 '${link}'",
    ]}),
  }
}
