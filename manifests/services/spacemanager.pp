define dcache::services::spacemanager (
  $domain,
  $linkgroupauth,
  $properties = {},
) {
  require dcache
  
  file { $dcache::linkgroupauth_path:
    owner   => $dcache::user,
    group   => $dcache::group,
    content => epp('dcache/linkgroupauth.epp', { content => $linkgroupauth, }),
  }
  
  dcache::services::generic { 'spacemanager':
    domain     => $domain,
    properties => $properties,
  }
}