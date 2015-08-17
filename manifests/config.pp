# Apply config changes for dCache.
# Right now, because versatile modules aren ot ready, this means
# sourcing the layout file and all configuration files related to the
# services from a Git repository.
class dcache::config (
  $domains = $dcache::domains,
) {
  
  dcache::java { 'Install Java': }
  
  dcache::install { 'Install dCache': }
  
  dcache::layout { 'Get layout': }

  dcache::config_file { 'dcache.conf': }
  
  create_resources('dcache::domain', $domains)
  
}