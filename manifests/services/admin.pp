define dcache::services::admin (
  $properties = {}, # ... will be ignored.
  $auth_keys_file = "$dcache::admin_authorized_keys",
  $user = "$dcache::dcache_user",
  $keys = {},
) {
  create_resources(ssh_authorized_keys, $keys,
                   { target => "$auth_keys_file", user => "$user", }
  )
}