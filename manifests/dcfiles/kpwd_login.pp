define dcache::dcfiles::kpwd_login (
  $access, $uid, $gid, $home, $root, $fsroot='/', $dns,
) {
  augeas { "Add kpwd login record for ${title}":
    changes => flatten([
      "defnode this login[. = '${title}'] '${title}'",
      "set \$this/access '${access}'",
      "set \$this/uid '${uid}'",
      "set \$this/gid '${gid}'",
      "set \$this/home '${home}'",
      "set \$this/root '${root}'",
      "set \$this/fsroot '${fsroot}'",
      map($dns) |$dn| { "set \$this/dn[. = '${dn}'] '${dn}'" },
    ]),
  }
}