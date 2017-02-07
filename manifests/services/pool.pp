# Just syntactic sugar for defining a pool for dCache.
define dcache::services::pool (
  $size,
  $poolname = $title,
  $domain = "${title}Domain",
  $properties = {},
) {
  
  $the_properties = merge(
    $properties,
    {
      'pool.name' => $poolname,
      'pool.size' => $size,
    }
  )
  
  dcache::services::generic { $poolname:
    domain     => $domain,
    service    => 'pool',
    properties => $the_properties,
  }
}
