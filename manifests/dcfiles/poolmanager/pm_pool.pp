define dcache::dcfiles::poolmanager::pm_pool (
  $attr = [],
)  {
  $setup = $dcache::poolmanager
  
  augeas { "Create pool '$title' in '$setup'":
    name => "augeas_create_$title",
    changes => "set psu_create_pool[. = \"$title\"] \"$title\"",
  }
  
  validate_array($attr)
  each($attr) |$i, $a| {
    augeas { "Add attribute '$a' for pool '$title' in '$setup'":
      require => Augeas["augeas_create_$title"],
      changes => "set psu_create_pool[. = \"$title\"]/$i \"$a\"",
    }
  }
}