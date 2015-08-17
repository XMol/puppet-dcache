define dcache::services::admin (
  $auth_keys = $dcache::admin_paths_authorized_key,
) {
  # Have to wait for proper ssh key management with Puppet.
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}