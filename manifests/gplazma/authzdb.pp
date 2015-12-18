define dcache::gplazma::authzdb (
  $authzdb_file = "$dcache::authzdb_file",
  $content = undef,
  $source = undef,
  $augeas = undef,
) {
  File { 
    path => "$authzdb_file",
    owner => "$dcache::dcache_user",
    group => "$dcache::dcache_group",
  }
  
  Augeas {
    incl => "$authzdb_file",
  }
  
  # Augeas cannot create the file from scratch (for whatever reason), so we
  # have to make sure it exists already in a valid state before, which
  # may be changed right after.
  file { "Ensure '$authzdb_file' exists":
    content => '#Dummy file\nversion 2.1\n',
    replace => false,
  }
  
  if $content {
    # Only act for one of the parameters and fail if more are set.
    if $source or $augeas {
      fail('Only one out of $content, $source or $augeas may be set!')
    }
    validate_string($content)
    file { "Set content of '$authzdb_file'":
      content => "$content",
    }
  } elsif $source {
    if $augeas {
      fail('Only one out of $content, $source or $augeas may be set!\n')
    }
    file { "Source '$authzdb_file'":
      source => "$source",
    }
  } elsif $augeas {
    validate_hash($augeas)
    # This hash must always feature a 'version' key, since it is required
    # in the authzdb file, too.
    unless has_key($augeas, 'version') {
      fail(join(['The authzdb file must contain a version setting,',
                 'but it is missing from the $augeas hash!'], ' '))
    }
    each($augeas) |$key, $value| {
      if "$key" = "version" {
        augeas { "Manage 'version' in $authzdb_file":
          changes => "set version ${augeas['version']}",
        }
      } else {
#        augeas { "Add user '$key' to $authzdb_file":
#          changes => "ins $key after .[last()]",
#          onlyif => "match .[label() = \"$key\"] size = 0",
#        }
        # The 'extra' key is optional.
        $extra = pick(${augeas['extra']}, '/')
        augeas { "Update settings for '$key' in $authzdb_file":
          changes => flatten([
            "set $key/access ${augeas['access']}",
            "set $key/uid ${augeas['uid']}",
            map(${augeas['gid']}) |$index, $gid| {
              "set $key/gid[$index] $gid"
            },
            "set $key/home ${augeas['home']}",
            "set $key/root ${augeas['root']}",
            "set $key/extra $extra",
          ]),
        }
      }
    }
  } else {
    fail("At least one of the parameters for the authzdb resource must be set!")
  }
}