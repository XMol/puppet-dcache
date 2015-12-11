class dcache::config (
  $layout = $dcache::layout,
) {
  # Initiate the domains for this host.
  create_resources('dcache::domain', $layout['domains'])
  
  include dcache::augeas
  
  dcache::layout { "Generate the dCache layout file":
    layout => $layout,
  }
}