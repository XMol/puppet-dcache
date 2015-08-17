class dcache::yum (
  $version = $dcache::dcache_version,
) {
  # Only accept verion specification looking like a float, ie. with 
  # a single decimal point.
  if is_float($version) {
    yumrepo { "dcache-${version} repo":
      name => "dcache-${version}",
      descr => "dCache ${version} rpms on GridKa mirror",
      ensure => present,
      enabled => 1,
      baseurl => "ftp://mirror.gridka.de/www.dcache.org/${version}/";
    }
  } else {
    fail("Failed to parse dCache's version; got '${version}'.")
  }
}