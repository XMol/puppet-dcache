define dcache::dcfiles::authzb (
  $file,
  $augeas,
) {
  
  Augeas {
    lens => 'StorageAuthzdb', # Coming with this module.
    incl => $file,
  }
  
  if !has_key($augeas['version']) {
    fail('Authzdb requires a version setting!')
  }
  
  augeas { "Set version of authzdb in '$file'":
    changes => "set version ${augeas['version']}",
  }
  create_resources('dcache::dcfiles::authzb::rule',
                   delete($augeas, 'version'))
}

# To be used only by dcache::dcfiles:authzdb.
define dcache::dcfiles::authzb::rule (
  $access, $uid, $gids, $home, $root, $extra='/',
) {
  augeas { "Manage authzdb rule for user '$title'":
    changes => flatten([
      "defnode this \"$title\"",
      "set \$this/access \"$access\"",
      "set \$this/uid \"$uid\"",
      map($gids) |$i, $gid| { "set \$this/gid[$i] $gid" },
      "set \$this/root \"$root\"",
      "set \$this/home \"$home\"",
      "set \$this/extra \"$extra\"",
    ]),
  }
}