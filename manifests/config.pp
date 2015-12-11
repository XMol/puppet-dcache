class dcache::config (
  $domains = $dcache::domains,
) {
  # Initiate the domains for this host.
  create_resources('dcache::domain', $domains)
  
  include dcache::augeas
  
  dcache::layout { "Generate the dCache layout file":
    domains => $domains,
  }
}