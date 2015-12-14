class dcache (
  $dcache_version,
  $java_package,
  $layout,
  $plugins = [],
  
  $manage_yum_repo = $dcache::params::manage_yum_repo,
  $headnode = "$dcache::params::headnode",
  $hosts_service_chimera = "$dcache::params::hosts_service_chimera",
  $hosts_service_srm = "$dcache::params::hosts_service_srm",
  $hosts_service_httpd = "$dcache::params::hosts_service_httpd",
  $hosts_service_billing = "$dcache::params::hosts_service_billing",
  $hosts_service_broker = "$dcache::params::hosts_service_broker",
  $hosts_database_chimera = "$dcache::params::hosts_database_chimera",
  $hosts_database_srm = "$dcache::params::hosts_database_srm",
  $hosts_database_spacemanager = "$dcache::params::hosts_database_spacemanager",
  $hosts_database_pinmanager = "$dcache::params::hosts_database_pinmanager",
  
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
  $dcache_uid = "$dcache::params::dcache_uid",
  $dcache_group = "$dcache::params::dcache_group",
  $dcache_gid = "$dcache::params::dcache_gid",
  $poolbasedir = "$dcache::params::poolbasedir",
  $poolmanager_conf = "$dcache::params::poolmanager_conf",
  $admin_authorized_keys = "$dcache::params::admin_authorized_keys",
  $gplazma_conf = "$dcache::params::gplazma_conf",
  $authzdb_file = "$dcache::params::authzdb_file",
  $gridmap_file = "$dcache::params::gridmap_file",
  $kpwd_file = "$dcache::params::kpwd_file",
  $vorolemap_file = "$dcache::params::vorolemap_file",
  $dcache_hostcert = "$dcache::params::dcache_hostcert",
  $dcache_hostkey = "$dcache::params::dcache_hostkey",
  $infoprovider_tapeinfo = "$dcache::params::infoprovider_tapeinfo",
  $infoprovider_xml = "$dcache::params::infoprovider_xml",
  $linkgroupauthconf = "$dcache::params::linkgroupauthconf",

  $custom_setup = {},  
) inherits dcache::params {
  
  # Merge the default setup and supplied setup.
  $setup = merge($setup, $custom_setup)
  
  class { dcache::install: } ->
  class { dcache::config: } ->
  class { dcache::service: }
  
}
