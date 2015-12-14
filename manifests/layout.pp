# Generate the layout file for a host.
# The layout file will be managed by Augeas. We will only ever change one
# specific file with a custom lens (which is autoloaded).
define dcache::layout (
  $layout,
  $layout_file = "$dcache::dcache_layout_file",
) {
  require dcache::augeas
  
  Augeas { incl => "$layout_file", }
  
  each($layout['properties']) |$prop_key, $prop_value| {
    augeas { "Add bare property '$prop_key' to the layout file":
      changes => "set ./$prop_key \"$prop_value\"",
    }
  }
  
  each($layout['domains']) |$domain, $dhash| {
    augeas { "Add domain '$domain' to the layout file":
      changes => "set ./\\[domain\\][. = \"$domain\"] \"$domain\"",
    }
    each($dhash['properties']) |$prop_key, $prop_value| {
      augeas { "Add $domain property $prop_key to the layout file":
        changes => "set ./\\[domain\\]/$prop_key \"$prop_value\"",
      }
    }
    each($dhash['services']) |$service, $shash| {
      augeas { "Add service '$service' to domain '$domain' in the layout file":
        changes => "set ./\\[domain\\]/\\[service\\][. = \"$domain/$service\"] \"$domain/$service\"",
      }
      each($shash['properties']) |$prop_key, $prop_value| {
        augeas { "Add $service property $prop_key to the layout file":
          changes => "set ./\\[domain\\]/\\[service\\]/$prop_key \"$prop_value\"",
        }
      }
    }
  }
}