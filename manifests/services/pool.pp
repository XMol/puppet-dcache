# @summary Just syntactic sugar for defining a pool for dCache.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties for this service instance.
# @param size
#   The designated total size of the pool.
# @param poolname
#   The name of the pool cell.
#
define dcache::services::pool (
  Integer[1] $size,
  String[1] $poolname = $title,
  String[1] $domain = "${title}Domain",
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install


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
