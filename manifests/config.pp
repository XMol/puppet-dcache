class dcache::config (
) {
  
  $all_files = {
    'dcache.conf' => {
      file     => $dcache::setup,
      source   => $dcache::setup_source,
      content  => $dcache::setup_content,
      template => $dcache::setup_template,
      augeas   => $dcache::setup_augeas,
      resource => 'simple',
    },
    'dcache.env' => {
      file     => $dcache::env,
      source   => $dcache::env_source,
      content  => $dcache::env_content,
      template => $dcache::env_template,
      augeas   => $dcache::env_augeas,
      resource => 'simple',
    },
    'layout' => {
      file     => $dcache::layout,
      source   => $dcache::layout_source,
      content  => $dcache::layout_content,
      template => $dcache::layout_template,
      augeas   => $dcache::layout_augeas,
      resource => 'layout',
    },
    'poolmanager.conf' => {
      file     => $dcache::poolmanager,
      source   => $dcache::poolmanager_source,
      content  => $dcache::poolmanager_content,
      template => $dcache::poolmanager_template,
      augeas   => $dcache::poolmanager_augeas,
      resource => 'poolmanager',
    },
    'authorized_keys2' => {
      file     => $dcache::authorized_keys,
      source   => $dcache::authorized_keys_source,
      content  => $dcache::authorized_keys_content,
      augeas   => $dcache::authorized_keys_augeas,
      resource => 'authkeys',
    },
    'gplazma.conf' => {
      file     => $dcache::gplazma,
      source   => $dcache::gplazma_source,
      content  => $dcache::gplazma_content,
    },
    'storage-authzdb' => {
      file     => $dcache::authzdb,
      source   => $dcache::authzdb_source,
      content  => $dcache::authzdb_content,
      template => $dcache::authzdb_template,
      augeas   => $dcache::authzdb_augeas,
      resource => 'authzdb',
    },
    'grid-mapfile' => {
      file     => $dcache::gridmap,
      source   => $dcache::gridmap_source,
      content  => $dcache::gridmap_content,
      template => $dcache::gridmap_template,
      augeas   => $dcache::gridmap_augeas,
      resource => 'gridmapfile',
    },
    'dcache.kpwd' => {
      file     => $dcache::kpwd,
      source   => $dcache::kpwd_source,
      content  => $dcache::kpwd_content,
      template => $dcache::kpwd_template,
      augeas   => $dcache::kpwd_augeas,
      resource => 'kpwd',
    },
    'grid-vorolemap' => {
      file     => $dcache::vorolemap,
      source   => $dcache::vorolemap_source,
      content  => $dcache::vorolemap_content,
      template => $dcache::vorolemap_template,
      augeas   => $dcache::vorolemap_augeas,
      resource => 'gridmapfile',
    },
    'tape-info.xml' => {
      file     => $dcache::tapeinfo,
      source   => $dcache::tapeinfo_source,
      content  => $dcache::tapeinfo_content,
    },
    'info-provider.xml' => {
      file     => $dcache::infoprovider,
      source   => $dcache::infoprovider_source,
      content  => $dcache::infoprovider_content,
    },
    'LinkGroupAuthorization.conf' => {
      file     => $dcache::linkgroupauth,
      source   => $dcache::linkgroupauth_source,
      content  => $dcache::linkgroupauth_content,
      template => $dcache::linkgroupauth_template,
      augeas   => $dcache::linkgroupauth_augeas,
      resource => 'linkgroupauth',
    },
    'exports' => {
      file     => $dcache::exports,
      source   => $dcache::exports_source,
      content  => $dcache::exports_content,
      template => $dcache::exports_template,
      augeas   => $dcache::exports_augeas,
      resource => 'exports',
    },
  }
  
  create_resources('dcache::dcfile', $all_files)
}