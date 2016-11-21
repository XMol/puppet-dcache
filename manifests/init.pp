class dcache (
  # Need to know which dCache version ought to be installed. Though we rely on
  # external administration to make the packages available.
  $version,
  $user = $dcache::params::user,
  $group = $dcache::params::group,
  
  # A file sourced by dCache on initializiation, so arbitrary environment
  # variables can be set, specifically JAVA and JAVA_HOME.
  $env_path = $dcache::params::env_path,
  $env = {},
  # dCache's central dcache.conf file.
  $setup_path = $dcache::params::setup_path,
  $setup = {},
  $layout_path = $dcache::params::layout_path,
  $layout_globals = {},
  
  $poolmanager_path = $dcache::params::poolmanager_path,
  $authorized_keys_path = $dcache::params::authorized_keys_path,
  $gplazma_path = $dcache::params::gplazma_path,
  $authzdb_path = $dcache::params::authzdb_path,
  $gridmap_path = $dcache::params::gridmap_path,
  $kpwd_path = $dcache::params::kpwd_path,
  $vorolemap_path = $dcache::params::vorolemap_path,
  $tapeinfo_path = $dcache::params::tapeinfo_path,
  $infoprovider_path = $dcache::params::infoprovider_path,
  $exports_path = $dcache::params::exports_path,
  $linkgroupauth_path = $dcache::params::linkgroupauth_path,
) inherits dcache::params {
  
  class { 'dcache::install': } ->
  class { 'dcache::config': }
  
}
