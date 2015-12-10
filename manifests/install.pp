class dcache::install (
  $manage_yum_repo = $dcache::manage_yum_repo,
  $version = $dcache::dcache_version,
) {
  class { dcache::java: }
  
  if $manage_yum_repo {
      class { dcache::yum: }
  }

  package { 'dcache' :
    name   => "dcache-${version}",
  }
    
}