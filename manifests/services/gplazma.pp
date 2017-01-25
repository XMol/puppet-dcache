define dcache::services::gplazma (
  $domain,
  $gplazma,
  $authzdb = {},
  $gridmap = {},
  $kpwd = {},
  $vorolemap = {},
  $properties = {},
  $gplazma_path = $dcache::gplazma_path,
  $authzdb_path = $dcache::authzdb_path,
  $gridmap_path = $dcache::gridmap_path,
  $kpwd_path = $dcache::kpwd_path,
  $vorolemap_path = $dcache::vorolemap_path,
) {
  require dcache
  
  File {
    owner   => $dcache::user,
    group   => $dcache::group,
  }
  
  # The gplazma.conf is tricky to be managed by Augeas or template and
  # defining it in YAML style doesn't save effort anyway.
  file { $gplazma_path:
    content => $gplazma,
  }
  
  if $authzdb != {} {
    file { $authzdb_path:
      content => epp('dcache/authzdb.epp', { content => $authzdb, }),
    }
  }
  
  if $gridmap != {} {
    file { $gridmap_path:
      content => epp('dcache/gridmapfile.epp', { content => $gridmap, }),
    }
  }
  
  if $vorolemap != {} {
    file { $vorolemap_path:
      content => epp('dcache/gridmapfile.epp', { content => $vorolemap, }),
    }
  }
  
  if $kpwd != {} {
    file { $kpwd_path:
      content => epp('dcache/kpwd.epp', { content => $kpwd, }),
    }
  }
  
  dcache::services::generic { 'gplazma':
    domain     => $domain,
    properties => $properties,
  }
}