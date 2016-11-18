define dcache::services::poolmanager (
  $domain,
  $properties = {},
  $poolmanager = $dcache::poolmanager,
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