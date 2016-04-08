define dcache::dcfiles::poolmanager (
  $file,
  $augeas,
) {
  
  Augeas {
    lens => 'PoolManager.lns', # Lens installed with this Puppet module.
    incl => $file,
  }
  
  if has_key($augeas, 'rc') {
    validate_hash($augeas['rc'])
    augeas { "Manage recall module settings in '${file}'":
      changes => map($augeas['rc']) |$key, $value| {
        "set rc_set_${key} ${value}"
      },
    }
  }
  
  if has_key($augeas, 'pm') {
    each($augeas['pm']) |$pm, $settings| {
      validate_hash($settings)
      augeas { "Manage partition '${pm}' in '${file}'":
        name    => "augeas_create_${pm}",
        changes => flatten([
          "set pm_create[. = '${pm}'] '${pm}'",
          "defnode this pm_set[. = '${pm}'] '${pm}'",
          map(delete($settings, 'type')) |$key, $value| {
            "set \$this/${key} '${value}'"
          }
        ]),
      }
      if has_key($settings, 'type') {
        augeas { "Set type of partition '${pm}' in '${file}'":
          require => Augeas["augeas_create_${pm}"],
          changes => "set pm_create[. = '${pm}']/type ${settings['type']}",
        }
      }
    }
  }
  
  if has_key($augeas, 'cm') {
    validate_hash($augeas['cm'])
    augeas { "Manage cost module settings in '${file}'":
      changes => map($augeas['cm']) |$key, $value| {
        "set cm_${key} ${value}"
      },
    }
  }
  
  # Rework the $augeas into a easily digestable hash that groups all the
  # different PoolManager objects in lists.
  $pm = process_pm_hash($augeas)
  
  # Declare the resources virtually first.
  create_resources('@dcache::dcfiles::poolmanager::pm_units', {'The PoolManager units' => $pm['units']})
  each($pm['ugroups']) |$ugroup, $units| {
    @dcache::dcfiles::poolmanager::pm_ugroup { $ugroup: units => $units, }
  }
  @dcache::dcfiles::poolmanager::pm_pool { $pm['pools']: }
  each($pm['pgroups']) |$pgroup, $pools| {
    @dcache::dcfiles::poolmanager::pm_pgroup { $pgroup: pools => $pools, }
  }
  create_resources('@dcache::dcfiles::poolmanager::pm_link', $pm['links'])
  create_resources('@dcache::dcfiles::poolmanager::pm_lgroup', $pm['lgroups'])
  
  # Then realize them in the right order.
  Dcache::Dcfiles::Poolmanager::Pm_units <| |> ->
    Dcache::Dcfiles::Poolmanager::Pm_ugroup <| |>
  Dcache::Dcfiles::Poolmanager::Pm_pool <| |> ->
    Dcache::Dcfiles::Poolmanager::Pm_pgroup <| |>
  Dcache::Dcfiles::Poolmanager::Pm_ugroup <| |> ->
    Dcache::Dcfiles::Poolmanager::Pm_link <| |>
  Dcache::Dcfiles::Poolmanager::Pm_pgroup <| |> ->
    Dcache::Dcfiles::Poolmanager::Pm_link <| |>
  Dcache::Dcfiles::Poolmanager::Pm_link <| |> ->
    Dcache::Dcfiles::Poolmanager::Pm_lgroup <| |>
}
