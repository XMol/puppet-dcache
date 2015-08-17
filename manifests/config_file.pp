# Until we have developed modules that will generate/edit configuration
# files for dCache properly, we just source them from a Git repository.
define dcache::config_file (
  $path = $dcache::dcache_dirs_etc,
  $source = 'dcache_config',
) {
  require dcache::install
  
  File {
    source => "puppet:///modules/${source}/${dcache::experiment}/${name}",
    ensure => present,
    owner  => "${dcache::dcache_user}",
    group  => "${dcache::dcache_group}",
    notify => Service['dcache'],
  }
  file { "Source ${name}":
    path => "${path}/${name}",
  }
}