class dcache::install (
  $manage_yum_repo = $dcache::manage_yum_repo,
  $version = $dcache::dcache_version,
) {
  class { dcache::java: }
  
  if $manage_yum_repo {
    if $version =~ /^(\d+)\.(\d+)\.(\d+)$/ {
      class { dcache::yum: }
    }
  }
  
  package { 'dcache' :
    name   => "dcache-${version}",
    ensure => installed,
  }~>
  exec { '/etc/init.d/dcache':
    refreshonly => true,
    command     => "ln -fs $(rpm -ql dcache-${version} | sed -n '\\+/dcache$+ p) ${title}",
    path        => '/bin',
  }->
  service { 'dcache':
    ensure    => $dcache::service_status,
    enable    => $dcache::manage_service,
  }
}