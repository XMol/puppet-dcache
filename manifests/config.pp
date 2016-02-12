class dcache::config (
) {
  
  $all_files = {
    'dcache.conf' => {
      file => $dcache::setup,
      content => $dcache::setup_content,
      source => $dcache::setup_source,
      augeas => $dcache::setup_augeas,
      resource => 'simple',
    },
    'dcache.env' => {
      file => $dcache::env,
      content => $dcache::env_content,
      source => $dcache::env_source,
      augeas => $dcache::env_augeas,
      resource => 'simple',
    },
    'layout' => {
      file => $dcache::layout,
      content => $dcache::layout_content,
      source => $dcache::layout_source,
      augeas => $dcache::layout_augeas,
      resource => 'layout',
    },
    'poolmanager.conf' => {
      file => $dcache::poolmanager,
      content => $dcache::poolmanager_content,
      source => $dcache::poolmanager_source,
      augeas => $dcache::poolmanager_augeas,
      resource => 'poolmanager',
    },
    'authorized_keys2' => {
      file => $dcache::authorized_keys,
      content => $dcache::authorized_keys_content,
      source => $dcache::authorized_keys_source,
      augeas => $dcache::authorized_keys_augeas,
      resource => 'authkeys',
    },
    'gplazma.conf' => {
      file => $dcache::gplazma,
      content => $dcache::gplazma_content,
      source => $dcache::gplazma_source,
      resource => 'Only required for Augeas.',
    },
    'storage-authzdb' => {
      file => $dcache::authzdb,
      content => $dcache::authzdb_content,
      source => $dcache::authzdb_source,
      augeas => $dcache::authzdb_augeas,
      resource => 'authzdb',
    },
    'gridmap-file' => {
      file => $dcache::gridmap,
      content => $dcache::gridmap_content,
      source => $dcache::gridmap_source,
      augeas => $dcache::gridmap_augeas,
      resource => 'gridmap',
    },
    'dcache.kpwd' => {
      file => $dcache::kpwd,
      content => $dcache::kpwd_content,
      source => $dcache::kpwd_source,
      augeas => $dcache::kpwd_augeas,
      resource => 'kpwd',
    },
    'vorolemap' => {
      file => $dcache::vorolemap,
      content => $dcache::vorolemap_content,
      source => $dcache::vorolemap_source,
      augeas => $dcache::vorolemap_augeas,
      resource => 'vorolemap',
    },
    'tape-info.xml' => {
      file => $dcache::tapeinfo,
      content => $dcache::tapeinfo_content,
      source => $dcache::tapeinfo_source,
      resource => 'Only required for Augeas.',
    },
    'info-provider.xml' => {
      file => $dcache::infoprovider,
      content => $dcache::infoprovider_content,
      source => $dcache::infoprovider_source,
      resource => 'Only required for Augeas.',
    },
    'LinkGroupAuthorization.conf' => {
      file => $dcache::linkgroupauth,
      content => $dcache::linkgroupauth_content,
      source => $dcache::linkgroupauth_source,
      augeas => $dcache::linkgroupauth_augeas,
      resource => 'linkgroupauth',
    },
  }
  
  create_resources('dcache::dcfile', $all_files)
}