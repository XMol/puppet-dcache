define dcache::services::poolmanager (
  $domain,
  $poolmanager,
  $properties = {},
) {
  require dcache
  
  file { $dcache::poolmanager_path:
    owner   => $dcache::user,
    group   => $dcache::group,
    content => epp('dcache/poolmanager.epp', { content => $poolmanager, }),
  }
  
  dcache::services::generic { 'poolmanager':
    domain     => $domain,
    properties => $properties,
  }
}