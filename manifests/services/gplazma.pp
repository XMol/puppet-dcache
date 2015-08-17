define dcache::gplazma (
  $gplazma       = $dcache::gplazma_configuration_file,
  $kpwd          = $dcache::gplazma_kpwd_file,
  $grid_security = $dcache::globals::dcache_dirs_grid_security,
  $gridmap       = $dcache::gplazma_gridmap_file,
  $authzdb       = $dcache::gplazma_authzdb_file,
  $vorolemap     = $dcache::gplazma_vorolemap_file,
) {
  dcache::config_file { [$gplazma, $kpwd]: }
  dcache::config_file { [$gridmap, $authzdb, $vorolemap]:
    path => "$grid_security",
  }
}