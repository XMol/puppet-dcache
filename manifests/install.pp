class dcache::install (
  $version = $dcache::version,
) {
  package { 'dcache' :
    name   => "dcache-${version}",
  }
    
}