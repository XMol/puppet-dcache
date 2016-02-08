define dcache::dcfiles::poolmanager::pm_units (
  $net = [],
  $store = [],
  $protocol = [],
  $dcache = [],
) {
  $setup = $dcache::poolmanager
  
  validate_array($net)
  each($net) |$unit| {
    augeas { "Create net-unit '$unit' in '$setup'":
      changes => [
        "defnode this psu_create_unit[. = \"$title\" and type = \"net\"] \"$title\"",
        "set \$this/type \"net\"",
      ]
    }
  }
  
  validate_array($store)
  each($store) |$unit| {
    augeas { "Create store-unit '$unit' in '$setup'":
      changes => [
        "defnode this psu_create_unit[. = \"$title\" and type = \"store\"] \"$title\"",
        "set \$this/type \"store\"",
      ]
    }
  }
  
  validate_array($protocol)
  each($protocol) |$unit| {
    augeas { "Create protocol-unit '$unit' in '$setup'":
      changes => [
        "defnode this psu_create_unit[. = \"$title\" and type = \"protocol\"] \"$title\"",
        "set \$this/type \"protocol\"",
      ]
    }
  }
  
  validate_array($dcache)
  each($dcache) |$unit| {
    augeas { "Create dcache-unit '$unit' in '$setup'":
      changes => [
        "defnode this psu_create_unit[. = \"$title\" and type = \"dcache\"] \"$title\"",
        "set \$this/type \"dcache\"",
      ]
    }
  }
}