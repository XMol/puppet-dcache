class dcache::install (
  $version = $dcache::version,
) {
  require dcache

  package { 'dcache' :
    name => "dcache-${version}",
  }

  # Ensure correct owner on directories dCache wants to write into.
  file { [$dcache::params::paths_admin,
          $dcache::params::paths_lib,
          $dcache::params::paths_log]:
    ensure  => 'directory',
    owner   => $dcache::user,
    group   => $dcache::group,
    require => Package['dcache'],
  }
}
