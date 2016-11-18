define dcache::services::pool (
  $domain,
  $properties = {},
) {
  require dcache
  
  dcache::services::generic { "${domain}/${title}":
    domain     => $domain,
    service    => 'pool',
    properties => $properties,
  }
}