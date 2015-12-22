define dcache::gplazma (
  $properties = {},
  $gplazma = {},
  $authzdb = {},
  $gridmap = {},
  $kpwd = {},
  $vorolemap = {},
) {
  
  if $gplazma {
    ensure_resource('dcache::gplazma::gplazma_conf', $gplazma)
  }
  
  if $authzdb {
    ensure_resource('dcache::gplazma::authzdb', $authzdb)
  }
  
  if $gridmap {
    ensure_resource('dcache::gplazma::gridmap', $gridmap)
  }

  # Reuse the same resource for the vorolemap.
  if $vorolemap {
    ensure_resource('dcache::gplazma::gridmap', $vorolemap)
  }
  
  if $kpwd {
    ensure_resource('dcache::gplazma::kpwd', $kpwd)
  }

}