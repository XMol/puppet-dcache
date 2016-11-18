define dcache::services::poolmanager (
  $domain,
  $layout = $dcache::layout,
  $properties = {},
  $poolmanager = $dcache::poolmanager,
) {
  require dcache
  
  file { $poolmanager_path:
    owner   => $dcache::user,
    group   => $dcache::group,
    content => epp('dcache/poolmanager.epp', { content => $poolmanager, })
  }
  
  dcache::services::generic { "${domain}/poolmanager":
    domain     => $domain,
    service    => 'poolmanager',
    properties => $properties,
  }
}