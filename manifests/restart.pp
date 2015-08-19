# Whenever some configuration file gets changed, we possibly want to
# restart dCache. However, notifying Service['dcache'] by config_files
# creates a dependency cycle with dcache::install. Thus we need this
# additional class, which will be realized last (as long as we avoid
# dependencies to any other class, that is).
class dcache::restart (
  $domain = '',
) {
  
  exec { 'dcache restart':
    path        => '/usr/bin',
    command     => "dcache restart ${domain}",
    onlyif      => $dcache::service_status,
    refreshonly => true,
    require     => Class['dcache::service'],
  }

}