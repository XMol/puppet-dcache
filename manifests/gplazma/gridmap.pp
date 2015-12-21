define dcache::gplazma::gridmap (
  $gridmap_file = "$dcache::gridmap_file",
  $content = undef,
  $source = undef,
  $augeas = undef,
) {
  File { 
    path => "$gridmap_file",
    owner => "$dcache::dcache_user",
    group => "$dcache::dcache_group",
  }
  
  Augeas {
    incl => "$gridmap_file",
  }
  
  if $content {
    # Only act for one of the parameters and fail if more are set.
    if $source or $augeas {
      fail('Only one out of $content, $source or $augeas may be set!')
    }
    validate_string($content)
    file { "Set content of '$gridmap_file'":
      content => "$content",
    }
  } elsif $source {
    if $augeas {
      fail('Only one out of $content, $source or $augeas may be set!\n')
    }
    file { "Source '$gridmap_file'":
      source => "$source",
    }
  } elsif $augeas {
    validate_array($augeas)
    each($augeas) |$index, $mapping| {
      validate_hash($mapping)
      if has_key($mapping, 'fqan') {
        augeas { "Update mapping for '${mapping['dn']} + ${mapping['fqan']}' in '$gridmap_file'":
          changes => [
            "defnode this mapping[dn = \"${mapping['dn']}\"][fqan = \"${mapping['fqan']}\"]",
            "set \$this/dn \"${mapping['dn']}\"",
            "set \$this/fqan \"${mapping['fqan']}\"",
            "set \$this/login \"${mapping['login']}\"",
          ],
        }
      } else {
        augeas { "Update mapping for '${mapping['dn']}' in '$gridmap_file'":
          changes => [
            "defnode this mapping[dn = \"${mapping['dn']}\"]",
            "set \$this/dn \"${mapping['dn']}\"",
            "set \$this/login \"${mapping['login']}\"",
          ],
        }
      }
    }
  } else {
    fail("At least one of the parameters for the gridmap resource must be set!")
  }
}