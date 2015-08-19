define dcache::domain (
  $options  = [],
  $services = {},
) {
  
  each($services) |$service, $params| {
    # $params may be unset, but is required to be a hash, even an empty one
    # does suffice.
    if ! $params { $secure_params = {} }
            else { $secure_params = $params }
    
    $splitted = split($service, ',')
    if size($splitted) == 1 { $mytitle = "${name}->${service}" }
                       else { $mytitle = "${splitted[1]}"}
    
    ensure_resource("dcache::services::${splitted[0]}",
                    $mytitle, $secure_params)
  }

}