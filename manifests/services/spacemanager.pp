define dcache::services::spacemanager (
  $lga = $dcache::spacemanager_authz_link_group_file_name,
) {
  dcache::config_file { basename($lga):
  }

  if $dcache::debug { notify { "realized $title":  } }
}