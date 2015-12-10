class dcache::service (
  $service_exec = $dcache::service_exec,
  $service_exec_orig = $dcache::service_exec_orig,
) {
  
  exec { "Create symbolic link $service_exec":
    refreshonly => true,
    command     => "ln -fs $(rpm -ql dcache-${dcache::dcache_version} | grep -e '/dcache$') ${service_exec}",
    path        => '/bin',
    subscribe   => Package['dcache'],
  } ->  
  exec { "Add dcache to check-config":
    refreshonly => true,
    command => "chkconfig --add $(basename $service_exec)",
    path => '/bin',
    unless => "chkconfig --list $(basename $service_exec)",
  }
  
  file { "Remove original dCache init script":
    path => "$service_exec_orig",
    ensure => absent,
  }
  
}