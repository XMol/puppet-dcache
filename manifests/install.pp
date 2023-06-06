# @summary Install dCache rpms and fix owner and gid of resources.
#
# @api private
#
class dcache::install () {
  require dcache

  $etc_dir = lookup('dcache::setup."dcache.paths.etc"')
  $lib_dir = lookup('dcache::setup."dcache.paths.lib"')
  $log_dir = lookup('dcache::setup."dcache.log.dir"')

  package { 'dcache' :
    ensure => $dcache::version,
  }
  # Ensure correct owner on directories dCache wants to write into.
  -> file { [$etc_dir, $lib_dir, $log_dir,]:
    ensure => 'directory',
    owner  => $dcache::user,
    group  => $dcache::group,
  }
  ~> exec { 'Fix owner after dcache installation':
    path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin',],
    command     => "chown -R ${dcache::user}:${dcache::group} ${etc_dir} ${lib_dir} ${log_dir}",
    refreshonly => true,
  }
}
