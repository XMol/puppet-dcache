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
  $env_source = '',
  $env_content = '',
  $env_template = {},
  $env_augeas = {},
  
  # dCache's central dcache.conf file.
  $setup = $dcache::params::setup,
  $setup_source = '',
  $setup_content = '',
  $setup_template = {},
  $setup_augeas = {},
  
  $layout = $dcache::params::layout,
  $layout_source = '',
  $layout_content = '',
  $layout_template = {},
  $layout_augeas = {},
  
  $poolmanager = $dcache::params::poolmanager,
  $poolmanager_source = '',
  $poolmanager_content = '',
  $poolmanager_template = {},
  $poolmanager_augeas = {},
  
  $authorized_keys = $dcache::params::authorized_keys,
  $authorized_keys_source = '',
  $authorized_keys_content = '',
  $authorized_keys_template = {},
  $authorized_keys_augeas = {},
  
  $gplazma = $dcache::params::gplazma,
  $gplazma_source = '',
  $gplazma_content = '',
  # The gplazma.conf is tricky to be managed by Augeas or template and
  # defining it in YAML style doesn't save effort anyway..
  
  $authzdb = $dcache::params::authzdb,
  $authzdb_source = '',
  $authzdb_content = '',
  $authzdb_template = {},
  $authzdb_augeas = {},
  
  $gridmap = $dcache::params::gridmap,
  $gridmap_source = '',
  $gridmap_content = '',
  $gridmap_template = {},
  $gridmap_augeas = {},
  
  $kpwd = $dcache::params::kpwd,
  $kpwd_source = '',
  $kpwd_content = '',
  $kpwd_template = {},
  $kpwd_augeas = {},
  
  $vorolemap = $dcache::params::vorolemap,
  $vorolemap_source = '',
  $vorolemap_content = '',
  $vorolemap_template = {},
  $vorolemap_augeas = {},
  
  $tapeinfo = $dcache::params::tapeinfo,
  $tapeinfo_source = '',
  $tapeinfo_content = '',
  
  $infoprovider = $dcache::params::infoprovider,
  $infoprovider_source = '',
  $infoprovider_content = '',
  
  $linkgroupauth = $dcache::params::linkgroupauth,
  $linkgroupauth_source = '',
  $linkgroupauth_content = '',
  $linkgroupauth_template = {},
  $linkgroupauth_augeas = {},

) inherits dcache::params {
  
  class { 'dcache::install': } ->
  class { 'dcache::config': }
  
}
