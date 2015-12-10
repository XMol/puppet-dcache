class dcache::config (
  $domains = $dcache::domains,
) {
  # Create only the domains for this host.
  create_resources('dcache::domain', $domains[$::hostname])
  
}