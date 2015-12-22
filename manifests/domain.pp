# This resource simply realizes all the services of the domain. As for
# the domain resource, no more work is done.
define dcache::domain (
  $properties = {},
  $services,
) {
  
  each($services) |$service, $shash| {
    # $shash may be unset, but is required to be a hash, even an empty one
    # does suffice.
    # Every resource among the dcache::services must at least accept a
    # parameter 'properties', simply because that parameter is evaluated
    # by the dcache::layout class. For the actual resource, that parameter
    # is meaningless.
    if $shash {
      ensure_resource("dcache::services::$service", $service, $shash)
    } else {
      ensure_resource("dcache::services::$service", $service, {})
    }
    
  }

}