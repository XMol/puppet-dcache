define dcache::services::spacemanager (
  $domain,
  $linkgroupauth,
  $properties = {},
  $linkgroupauth_path = $dcache::linkgroupauth_path,
) {
  require dcache
  
  file { $linkgroupauth_path:
    owner => $dcache::user,
    group => $dcache::group,
    content => epp('dcache/linkgroupauth.epp', { content => $linkgroupauth, }),
  }
  
  dcache::services::generic { "${domain}/spacemanager":
    domain     => $domain,
    service    => 'spacemanager',
    properties => $properties,
  }
}