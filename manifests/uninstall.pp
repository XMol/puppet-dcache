class dcache::uninstall (
) {
  package { 'Uninstall dCache packages':
    ensure => absent,
    name   => 'dcache',
  } ->
  user { 'Remove dCache user "$dcache::user"':
    ensure => absent,
    name   => $dcache::user,
  } ->
  group { 'Remove dCache group "$dcache::group"':
    ensure => absent,
    name   => $dcache::group,
  }
}
