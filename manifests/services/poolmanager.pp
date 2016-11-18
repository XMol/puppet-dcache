define dcache::services::poolmanager (
  $domain,
  $properties = {},
  $poolmanager_path = $dcache::poolmanager_path,
) {
  require dcache
  
  file { $poolmanager_path:
    owner   => $dcache::user,
    group   => $dcache::group,
    content => epp('dcache/poolmanager.epp', { content => $poolmanager, })
  }
  
  dcache::services::generic { 'poolmanager':
    domain     => $domain,
    properties => $properties,
  }
}