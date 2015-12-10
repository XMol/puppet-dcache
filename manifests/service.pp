class dcache::service (
  $service_exec = $dcache::service_exec,
  $service_exec_orig = $dcache::service_exec_orig,
) {
  
  exec { "Create symbolic link $service_exec":
    refreshonly => true,
    command     => "ln -fs $(rpm -ql dcache-${dcache::dcache_version} | grep -e '/dcache$') ${service_exec}",
    path        => '/bin',
    subscribe   => Package['dcache'],
  }
  
  exec { "Remove original dCache init script":
    command => "/bin/rm $service_exec_orig",
    onlyif => "test -L $service_exec_orig",
    subscribe   => Package['dcache'],
  }
  
  exec { "Add dcache to check-config":
    refreshonly => true,
    command => "chkconfig --add $(basename $service_exec)",
    path => '/bin',
    subscribe   => Package['dcache'],
  }
  
}