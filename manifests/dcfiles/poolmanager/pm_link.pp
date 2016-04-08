define dcache::dcfiles::poolmanager::pm_link (
  $ugroups,
  $prefs = {},
  $pgroups = [],
) {
  $setup = $dcache::poolmanager

  augeas { "Create link '${title}' in '${setup}'":
    name    => "augeas_create_${title}",
    changes => flatten([
      "defnode this psu_create_link[. = '${title}'] '${title}'",
      map($ugroups) |$ugroup| {
        "set \$this/ugroup[. = '${ugroup}'] '${ugroup}'"
      },
    ]),
  }
  
  augeas { "Manage preferences on '${title}' in '${setup}'":
    changes => flatten([
      "defnode this psu_set_link[. = '${title}'] '${title}'",
      map($prefs) |$key, $value| {
        "set \$this/${key} '${value}'"
      }
    ]),
  }
  
  augeas { "Add member '${member}' to link '${title}' in '${setup}'":
    changes => flatten(map($pgroups) |$pgroup| {[
      "defnode this psu_addto_link[. = '${title}' and ./1 = '${pgroup}'] '${title}'",
      "set \$this/1 '${pgroup}'",
    ]}),
  }
}
