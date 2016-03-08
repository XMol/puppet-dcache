class dcache (
  
  # Need to know which dCache version ought to be installed. Though we rely on
  # external administration to make the packages available.
  $version,
  $user = $dcache::params::user,
  $group = $dcache::params::group,
  
  # A file sourced by dCache on initializiation, so arbitrary environment
  # variables can be set, specifically JAVA and JAVA_HOME.
  # There is the option to manage this file by giving its content explicitly
  # or a uri where the file can be sourced from or by using Augeas.
  $env = $dcache::params::env,
  $env_content = '',
  $env_source = '',
  $env_augeas = {},
  
  # dCache's central dcache.conf file.
  $setup = $dcache::params::setup,
  $setup_content = '',
  $setup_source = '',
  $setup_augeas = {},
  
  $layout = $dcache::params::layout,
  $layout_content = '',
  $layout_source = '',
  $layout_augeas = {},
  
  $poolmanager = $dcache::params::poolmanager,
  $poolmanager_content = '',
  $poolmanager_source = '',
  $poolmanager_augeas = {},
  
  $authorized_keys = $dcache::params::authorized_keys,
  $authorized_keys_content = '',
  $authorized_keys_source = '',
  $authorized_keys_augeas = {},
  
  $gplazma = $dcache::params::gplazma,
  $gplazma_content = '',
  $gplazma_source = '',
  # The gplazma.conf file cannot be managed properly with Augeas, since it
  # may contain duplicate lines and the order of the file's content matters.
  
  $authzdb = $dcache::params::authzdb,
  $authzdb_content = '',
  $authzdb_source = '',
  $authzdb_augeas = {},
  
  $gridmap = $dcache::params::gridmap,
  $gridmap_content = '',
  $gridmap_source = '',
  $gridmap_augeas = [],
  
  $kpwd = $dcache::params::kpwd,
  $kpwd_content = '',
  $kpwd_source = '',
  $kpwd_augeas = {},
  
  $vorolemap = $dcache::params::vorolemap,
  $vorolemap_content = '',
  $vorolemap_source = '',
  $vorolemap_augeas = [],
  
  $tapeinfo = $dcache::params::tapeinfo,
  $tapeinfo_content = '',
  $tapeinfo_source = '',
  
  $infoprovider = $dcache::params::infoprovider,
  $infoprovider_content = '',
  $infoprovider_source = '',
  
  $linkgroupauth = $dcache::params::linkgroupauth,
  $linkgroupauth_content = '',
  $linkgroupauth_source = '',
  $linkgroupauth_augeas = {},

) inherits dcache::params {
  
  class { 'dcache::install': } ->
  class { 'dcache::config': }
  
}
