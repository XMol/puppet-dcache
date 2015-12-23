define dcache::services::spacemanager (
  $lga = $dcache::linkgroupauthconf,
  $content = undef,
  $source = undef,
  $augeas = undef,
) {
  File { 
    path => "$lga",
    owner => "$dcache::dcache_user",
    group => "$dcache::dcache_group",
  }
  
  Augeas {
    incl => "$lga",
    lens => "LinkGroupAuthorization.lns", # Lens installed with this Puppet module.
  }
  
  if $content {
    # Only act for one of the parameters and fail if more are set.
    if $source or $augeas {
      fail('Only one out of $content, $source or $augeas may be set!')
    }
    validate_string($content)
    file { "Set content of '$lga'":
      content => "$content",
    }
  } 
  
  elsif $source {
    if $augeas {
      fail('Only one out of $content, $source or $augeas may be set!\n')
    }
    file { "Source '$lga'":
      source => "$source",
    }
  }
  
  elsif $augeas {
    validate_hash($augeas)
    each($augeas) |$lgroup, $members| {
      validate_array($members)
      augeas { "Manage linkGroup '$lgroup'":
        changes => flatten([
          "defnode this LinkGroup[. = \"$lgroup\"]",
          "set \$this \"$lgroup\"",
          map($members) |$index, $member| {
            "set \$this/entry[. = \"$member\"] \"$member\""
          },
        ]),
      }
    }
  }
}