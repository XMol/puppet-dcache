class dcache (
  # Need to know which dCache version ought to be installed. Though we rely on
  # external administration to make the packages available.
  $version,
  $user = $dcache::params::user,
  $group = $dcache::params::group,
  
  # A file sourced by dCache on initializiation, so arbitrary environment
  # variables can be set, specifically JAVA and JAVA_HOME.
  $env_path = $dcache::params::paths_env,
  $env = {},
  # dCache's central dcache.conf file.
  $setup_path = $dcache::params::paths_setup,
  $setup = {},
  $layout_path = $dcache::params::paths_layout,
  $layout_globals = {},
  
  $poolmanager_path = $dcache::params::paths_pm,
  $authorized_keys_path = $dcache::params::paths_authkeys,
  $gplazma_path = $dcache::params::paths_gplazma,
  $authzdb_path = $dcache::params::paths_authzdb,
  $gridmap_path = $dcache::params::paths_gridmap,
  $kpwd_path = $dcache::params::paths_kpwd,
  $vorolemap_path = $dcache::params::paths_vorolemap,
  $tapeinfo_path = $dcache::params::paths_tapeinfo,
  $infoprovider_path = $dcache::params::paths_infoprovider,
  $exports_path = $dcache::params::paths_exports,
  $linkgroupauth_path = $dcache::params::paths_lgauth,
) inherits dcache::params {
  
  class { 'dcache::install': } ->
  class { 'dcache::config': }
  
}
