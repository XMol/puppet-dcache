# Until we have proper modules to generate dCache's layout files,
# we just source them from a Puppet module.
define dcache::layout (
  $experiment = $dcache::experiment,
  $path = $dcache::dcache_dirs_layout,
) {
  
  $layout = "${::hostname}.conf"
  dcache::config_file { "${layout}":
    source => "puppet:///modules/dcache_config/${dcache::experiment}/layouts/${layout}",
    path   => "$path",
  }
}