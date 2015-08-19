class dcache::service (
  $status       = $dcache::service_status,
  $service      = $dcache::manage_service,
  $service_exec = $dcache::service_exec,
) {
  
  if $service == 'enabled' {
    exec { "$service_exec":
      refreshonly => true,
      command     => "ln -fs $(rpm -ql dcache-${dcache::dcache_version} | sed -n '\\+/dcache$+ p) ${service_exec}",
      path        => '/bin',
      subscribe   => Package['dcache'],
    }
    
    service { 'dcache':
      ensure  => $status,
      enable  => $service,
      require => Exec["${service_exec}"],
    }
  }
  
}