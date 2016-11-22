define dcache::services::admin (
  $domain,
  $authorized_keys,
  $properties = {},
  $authorized_keys_path = $dcache::authorized_keys_path,
) {
  require dcache
  
  create_resources('ssh_authorized_key',
    $authorized_keys,
    {
      target => $dcache::authorized_keys_path,
      user   => $dcache::user,
    }
  )
  
  dcache::services::generic { 'admin':
    domain     => $domain,
    properties => $properties,
  }
}