# Until we have developed modules that will generate/edit configuration
# files for dCache properly, we just source them from a Git repository.
define dcache::config_file (
  $path = $dcache::dcache_dirs_etc,
  $source = "puppet:///modules/dcache_config/${dcache::experiment}/${name}",
) {
  
  File {
    source => "${source}",
    ensure => present,
    owner  => "${dcache::dcache_user}",
    group  => "${dcache::dcache_group}",
    notify => Service['dcache'],
  }
  file { "Source ${name}":
    path => "${path}/${name}",
  }
}