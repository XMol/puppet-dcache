class dcache::config (
  $setup = $dcache::setup,
  $layout = $dcache::layout,
) {
  # Initiate the domains for this host.
  create_resources('dcache::domain', $layout['domains'])
  
  include dcache::augeas
  
  augeas { "Generate the dcache.conf file ('$setup')":
    incl => "$setup",
    lens => 'Simplevars',
    changes => map($setup) |$k, $v| { "set \"$k\" \"$v\"" },
  }
  
  dcache::layout { "Generate the dCache layout file":
    layout => $layout,
  }
}