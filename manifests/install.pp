class dcache::install (
  $version = $dcache::dcache_version,
) {
  package { 'dcache' :
    name   => "dcache-${version}",
  }
    
}