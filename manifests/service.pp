class dcache::service (
  $service_exec = $dcache::service_exec,
) {
  
  exec { "Add dcache to check-config":
    refreshonly => true,
    subscribe => Package['dcache'],
    command => "chkconfig --add $(basename $service_exec)",
    path => '/bin',
    unless => "chkconfig --list $(basename $service_exec)",
  }
  
}