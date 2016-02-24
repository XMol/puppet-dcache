define dcache::dcfiles::poolmanager::pm_units (
  $net = [],
  $store = [],
  $protocol = [],
  $dcache = [],
) {
  $setup = $dcache::poolmanager
  
  validate_array($net)
  each($net) |$unit| {
    if !defined(Augeas["Create net-unit '${unit}' in '${setup}'"]) {
      augeas { "Create net-unit '${unit}' in '${setup}'":
        changes => [
          "defnode this psu_create_unit[. = '${unit}' and type = 'net'] '${unit}'",
          'set $this/type "net"',
        ]
      }
    }
  }
  
  validate_array($store)
  each($store) |$unit| {
    if !defined(Augeas["Create store-unit '${unit}' in '${setup}'"]) {
      augeas { "Create store-unit '${unit}' in '${setup}'":
        changes => [
          "defnode this psu_create_unit[. = '${unit}' and type = 'store'] '${unit}'",
          'set $this/type "store"',
        ]
      }
    }
  }
  
  validate_array($protocol)
  each($protocol) |$unit| {
    if !defined(Augeas["Create protocol-unit '${unit}' in '${setup}'"]) {
      augeas { "Create protocol-unit '${unit}' in '${setup}'":
        changes => [
          "defnode this psu_create_unit[. = '${unit}' and type = 'protocol'] '${unit}'",
          'set $this/type "protocol"',
        ]
      }
    }
  }
  
  validate_array($dcache)
  each($dcache) |$unit| {
    if !defined(Augeas["Create dcache-unit '${unit}' in '${setup}'"]) {
      augeas { "Create dcache-unit '${unit}' in '${setup}'":
        changes => [
          "defnode this psu_create_unit[. = '${unit}' and type = 'dcache'] '${unit}'",
          'set $this/type "dcache"',
        ]
      }
    }
  }
}
