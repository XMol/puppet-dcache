class dcache::uninstall (
) {
  package { 'Uninstall dCache packages':
    name => 'dcache',
    ensure => absent,
  } ->
  exec { "Unregister dCache from check-config":
    command => "chkconfig --del $(basename $dcache::service_exec)",
    path => '/bin',
  } ->  
  tidy { 'Remove dCache yum repository files':
    require => Package['Uninstall dCache packages'],
    path => '/etc/yum.repos.d',
    matches => 'dcache-*',
  } ->
  file { ["$dcache::dcache_env",
          "$dcache::dcache_paths_etc",
          '/usr/share/dcache',
          '/var/lib/dcache',
          '/var/log/dcache',]:
    ensure => absent,
    force => true,
  } ->
  user { "Remove dCache user '$dcache::dcache_user'":
    name => "$dcache::dcache_user",
    ensure => absent,
  } ->
  group { "Remove dCache group '$dcache::dcache_group'":
    name => "$dcache::dcache_group",
    ensure => absent,
  }
}