define dcache::services::poolmanager (
  $path = $dcache::poolmanager_setup_file,
) {
  dcache::config_file { 'poolmanager.conf': 
    path => "${path}",
  }
}