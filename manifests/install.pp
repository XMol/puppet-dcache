class dcache::install (
  $version = $dcache::version,
) {
  package { 'dcache' :
    name   => "dcache-${version}",
  }
  
  # After installation, we need to potentially change the owner of
  # several directories, where dCache processes need write access.
  if $dcache::user != 'dcache' {
    exec { 'Correct wrong dCache user':
      refreshonly => true,
      subscribe   => Package['dcache'],
      path        => '/bin',
      command     => "chown -R ${dcache::user}:${dcache::group} ${dcache::params::paths_lib} ${dcache::params::paths_log}"
    }
  }
}