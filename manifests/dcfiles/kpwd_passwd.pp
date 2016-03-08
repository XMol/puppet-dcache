define dcache::dcfiles::kpwd_passwd (
  $pwdhash, $access, $uid, $gid, $home, $root, $fsroot='/',
) {
  augeas { "Add kpwd passwd record of login '${title}'":
    changes => flatten([
      "defnode this passwd[. = '${title}'] '${title}'",
      "set \$this/pwdhash '${pwdhash}'",
      "set \$this/access '${access}'",
      "set \$this/uid '${uid}'",
      "set \$this/gid '${gid}'",
      "set \$this/home '${home}'",
      "set \$this/root '${root}'",
      "set \$this/fsroot '${fsroot}'",
    ]),
  }
}