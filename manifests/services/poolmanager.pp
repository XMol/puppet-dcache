# @summary Add the poolmanager service to the layout and manage `poolmanager.conf`.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties for this service instance.
# @param cm
#   Settings for the PoolManager's cost module.
# @param pm
#   Settings for the PoolManager's partition module.
# @param rc
#   Settings for the PoolManager's recall module.
# @param psu
#   The entire hierarchy of the pools, units, links, etc.
#
define dcache::services::poolmanager (
  String[1] $domain,
  Hash[String[1], Scalar] $cm  = {},
  Hash[String[1], Hash[String[1], Scalar]] $pm  = {},
  Hash[String[1], Scalar] $rc  = {},
  Hash $psu = {}, # Delegate type verification to the ruby function
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install

  $poolmanager_conf = lookup('dcache::setup."poolmanager.setup.file"', Stdlib::Unixpath)
  concat { $poolmanager_conf:
    owner          => $dcache::user,
    group          => $dcache::group,
    order          => 'numeric',
    ensure_newline => true,
    warn           => true,
  }

  # Settings for the Cost Module.
  unless(empty($cm)) {
    concat::fragment { 'PoolManager.conf Cost Module settings':
      target  => $poolmanager_conf,
      order   => 20,
      content => join(sort(map($cm) |$k, $v| { "cm set ${k} ${v}" }), "\n"),
    }
  }

  # Settings for the Recall module.
  unless(empty($rc)) {
    $rc_rules = map($rc) |$k, $v| {
      # The syntax for setting 'onerror' is different from all others...
      $k ? { 'onerror' => "rc ${k} ${v}", default => "rc set ${k} ${v}" }
    }
    concat::fragment { 'PoolManager.conf Recall Module settings':
      target  => $poolmanager_conf,
      order   => 30,
      content => join(sort($rc_rules), "\n"),
    }
  }

  # Settings for the Partition Module.
  unless(empty($pm)) {
    $pm_rules = map($pm) |$part, $specs| {
      $type = then($specs['type']) |$t| { " -type=${t}" }
      $attributes = join(
        sort(
          map($specs - 'type') |$k , $v| {
            "-${k}=${v}"
          }
        ),
        ' '
      )
      "pm create${type} ${part}\npm set ${part} ${attributes}"
    }
    concat::fragment { 'PoolManager.conf Partition Manager settings':
      target  => $poolmanager_conf,
      order   => 40,
      content => join(sort($pm_rules), "\n"),
    }
  }

  # Build the psu hierarchy
  unless(empty($psu)) {
    $hierarchy = dcache::hash_to_psu($psu)
    concat::fragment {
      default:
        target  => $poolmanager_conf,
      ;
      'PoolManager.conf PSU units':
        order   => 44,
        content => epp("${module_name}/PoolManager/units.epp",
          { 'units' => $hierarchy['units'], }
        ),
      ;
      'PoolManager.conf PSU unit groups':
        order   => 45,
        content => epp("${module_name}/PoolManager/ugroups.epp",
          { 'ugroups' => $hierarchy['ugroups'] }
        ),
      ;
      'PoolManager.conf PSU pools':
        order   => 46,
        content => epp("${module_name}/PoolManager/pools.epp",
          { 'pools' => $hierarchy['pools'] }
        ),
      ;
      'PoolManager.conf PSU pool groups':
        order   => 47,
        content => epp("${module_name}/PoolManager/pgroups.epp",
          { 'pgroups' => $hierarchy['pgroups'] }
        ),
      ;
      'PoolManager.conf PSU links':
        order   => 48,
        content => epp("${module_name}/PoolManager/links.epp",
          { 'links' => $hierarchy['links'] }
        ),
      ;
      'PoolManager.conf PSU link groups':
        order   => 49,
        content => epp("${module_name}/PoolManager/lgroups.epp",
          { 'lgroups' => $hierarchy['lgroups'] }
        ),
      ;
    }
  }

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'poolmanager',
    properties => $properties,
  }
}
