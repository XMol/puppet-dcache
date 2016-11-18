define dcache::services::nfs (
  $domain,
  $exports,
  $properties = {},
  $exports_path = $dcache::exports_path,
) {
  require dcache
  
  augeas { $exports_path:
    incl    => $exports_path,
    lens    => 'Exports.lns',
    changes => flatten(map($exports) |$dir, $clients| {[
      "defnode dir dir[. = '${dir}'] '${dir}'",
      map($clients) |$client, $options| {[
        "defnode client \$dir/client[. = '${client}'] '${client}'",
        map($options) |$opt| {
          "set \$client/option[. = '${opt}'] '${opt}'"
        }
      ]}
    ]}),
  }
  
  dcache::services::generic { "${domain}/nfs":
    domain     => $domain,
    service    => 'nfs',
    properties => $properties,
  }
}