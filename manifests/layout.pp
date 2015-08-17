# Until we have proper modules to generate dCache's layout files,
# we just source them from a Puppet module.
define dcache::layout (
  $experiment = $dcache::experiment,
  $path = $dcache::dcache_dirs_layout,
  $source = 'dcache_config',
) {
  require dcache::install
  
  $layout = "${::hostname}.conf"
  file { "Source layout ${layout}":
    ensure => present,
    owner  => "${dcache::dcache_user}",
    group  => "${dcache::dcache_group}",
    source => "puppet:///modules/${source}/${experiment}/layouts/${layout}",
    path   => "$path/${layout}",
    notify => Service['dcache'],
  }
}