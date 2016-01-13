class dcache (
  $dcache_version,
  $java_package,
  $layout,
  
  $dcache_env = "$dcache::params::dcache_env",
  $dcache_paths_etc = "$dcache::params::dcache_paths_etc",
  $dcache_layout_file = "$dcache::params::dcache_layout_file",
  $dcache_paths_admin = "$dcache::params::dcache_paths_admin",
  $dcache_paths_setup = "$dcache::params::dcache_paths_setup",
  $dcache_paths_config = "$dcache::params::dcache_paths_config",
  $dcache_paths_gridsecurity = "$dcache::params::dcache_paths_gridsecurity",
  $dcache_paths_plugins = "$dcache::params::dcache_paths_plugins",
  $service_exec = "$dcache::params::service_exec",
  $dcache_user = "$dcache::params::dcache_user",
  $dcache_group = "$dcache::params::dcache_group",
  $poolmanager_conf = "$dcache::params::poolmanager_conf",
  $admin_authorized_keys = "$dcache::params::admin_authorized_keys",
  $gplazma_conf = "$dcache::params::gplazma_conf",
  $authzdb_file = "$dcache::params::authzdb_file",
  $gridmap_file = "$dcache::params::gridmap_file",
  $kpwd_file = "$dcache::params::kpwd_file",
  $vorolemap_file = "$dcache::params::vorolemap_file",
  $infoprovider_tapeinfo = "$dcache::params::infoprovider_tapeinfo",
  $infoprovider_xml = "$dcache::params::infoprovider_xml",
  $linkgroupauthconf = "$dcache::params::linkgroupauthconf",

  $setup = {},  
) inherits dcache::params {
  
  class { dcache::install: } ->
  class { dcache::config: } ->
  class { dcache::service: }
  
}
