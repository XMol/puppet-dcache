define dcache::services::gplazma (
  $domain,
  $gplazma,
  $authzdb = {},
  $gridmap = {},
  $kpwd = {},
  $vorolemap = {},
  $properties = {},
) {
  require dcache
  
  File {
    owner   => $dcache::user,
    group   => $dcache::group,
  }
  
  # The gplazma.conf is tricky to be managed by Augeas or template and
  # defining it in YAML style doesn't save effort anyway.
  file { $dcache::gplazma_path:
    content => $gplazma,
  }
  
  if $authzdb != {} {
    file { $dcache::authzdb_path:
      content => epp('dcache/authzdb.epp', { content => $authzdb, }),
    }
  }
  
  if $gridmap != {} {
    file { $dcache::gridmap_path:
      content => epp('dcache/gridmapfile.epp', { content => $gridmap, }),
    }
  }
  
  if $vorolemap != {} {
    file { $dcache::vorolemap_path:
      content => epp('dcache/gridmapfile.epp', { content => $vorolemap, }),
    }
  }
  
  if $kpwd != {} {
    file { $dcache::kpwd_path:
      content => epp('dcache/kpwd.epp', { content => $kpwd, }),
    }
  }
  
  dcache::services::generic { 'gplazma':
    domain     => $domain,
    properties => $properties,
  }
}
