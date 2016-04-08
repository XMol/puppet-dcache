define dcache::dcfiles::poolmanager::pm_pool (
)  {
  $setup = $dcache::poolmanager

  augeas { "Create pool '${title}' in '${setup}'":
    name    => "augeas_create_${title}",
    changes => "set psu_create_pool[. = '${title}'] '${title}'",
  }
  
}
