class dcache::uninstall (
) {
  package { 'Uninstall dCache packages':
    name => 'dcache',
    ensure => absent,
  } ->
  user { "Remove dCache user '$dcache::user'":
    name => "$dcache::user",
    ensure => absent,
  } ->
  group { "Remove dCache group '$dcache::group'":
    name => "$dcache::group",
    ensure => absent,
  }
}
