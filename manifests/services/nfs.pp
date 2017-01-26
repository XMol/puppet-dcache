define dcache::services::nfs (
  $domain,
  $exports,
  $properties = {},
) {
  require dcache
  
  augeas { $dcache::exports_path:
    incl    => $dcache::exports_path,
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
  
  dcache::services::generic { 'nfs':
    domain     => $domain,
    properties => $properties,
  }
}