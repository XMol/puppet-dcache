define dcache::services::poolmanager::pm_lgroup (
  $allowances,
  $members,
) {
  $setup = $dcache::poolmanager_conf
  
  augeas { "Create link group '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => "set psu_create_linkGroup[. = \"$title\"] \"$title\"",
  }
  
  validate_hash($allowances)
  augeas { "Set allowances of link group '$title' in '$setup'":
    require => Augeas["augeas_create_$title"],
    changes => flatten([
      map($allowances) |$key, $value| {[
        "defnode this psu_set_linkGroup_$key[. = \"$title\"]",
        "set \$this \"$title\"",
        "set \$this/1 \"$value\"",
      ]},
    ]),
  }

  validate_array($members)
  augeas { "Add members to link group '$title' in '$setup'":
    require => [ Augeas["augeas_create_$title"],
                 Dcache::Services::Poolmanager::Pm_link <| |>,
               ],
    changes => flatten([
      map($members) |$link| {[
        "defnode psu_addto_linkGroup[. = \"$title\" and ./1 = \"$link\"]",
        "set \$this \"$title\"",
        "set \$this/1 \"$link\"",
      ]},
    ]),
  }
}