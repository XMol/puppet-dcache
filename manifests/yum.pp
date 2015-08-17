class dcache::yum (
  $version = $dcache::dcache_version,
) {
  # Only use minor version (don't generate a new repo for every bug version).
  if $version =~ /^(\d+)\.(\d+)\.\d+$/ {
    $minvers = "$1.$2"
    yumrepo { "dcache-${minvers} repo":
      name => "dcache-${minvers}",
      descr => "dCache ${minvers} rpms on GridKa mirror",
      ensure => present,
      enabled => 1,
      baseurl => "ftp://mirror.gridka.de/www.dcache.org/${minvers}/";
    }
  } else {
    fail("Failed to parse dCache's version; got '${version}'.")
  }
}