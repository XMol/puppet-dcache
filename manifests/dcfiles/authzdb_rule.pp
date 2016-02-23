# To be used only by dcache::dcfiles_authzdb.
define dcache::dcfiles::authzdb_rule (
  $access, $uid, $gids, $home, $root, $extra='/',
) {
  augeas { "Manage authzdb rule for user '${title}'":
    changes => flatten([
      "defnode this '${title}' ''",
      "clear \$this",
      "set \$this/access '${access}'",
      "set \$this/uid '${uid}'",
      map($gids) |$i, $gid| { "set \$this/gid[${$i+1}] ${gid}" },
      "set \$this/home '${home}'",
      "set \$this/root '${root}'",
      "set \$this/extra '${extra}'",
    ]),
  }
}
