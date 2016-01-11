define dcache::services::poolmanager::pm_pool (
  $setup = $dcache::poolmanager_conf,
  $ping = undef,
  $enabled = undef,
)  {
  augeas { "Create pool '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => "set psu_create_pool[. = \"$title\"] \"$title\"",
  }

  if $ping {
    augeas { "Add noping for pool '$title' in '$setup'":
      require => Augeas["augeas_create_$title"],
      changes => "set psu_create_pool[. = \"$title\"]/ping \"noping\"",
    }
  }

  if $enabled {
    augeas { "Add disabled for pool '$title' in '$setup'":
      require => Augeas["augeas_create_$title"],
      changes => "set psu_create_pool[. = \"$title\"]/enabled \"disabled\"",
    }
  }
}