define dcache::dcfiles::exports (
  $file,
  $augeas,
) {

  augeas { "Manage '${file}' with Augeas":
    incl    => $file,
    lens    => 'Exports.lns',
    changes => flatten(map($augeas) |$dir| {[
      "defnode dir dir[. = '${dir}']",
      map($dir) |$client, $options| {[
        "defnode client \$dir/client[. = '${client}']",
        map($options) |$opt| {
          "set \$client/option[. = '${opt}'] '${opt}'"
        }
      ]}
    ]}),
  } ~>
  # Since $file is a simple list of arbitrary key value pairs, it is more
  # readable to have them sorted. Specifically for dcache.conf, where
  # properties for the same service are prefixed the same.
  exec { "Sort '${file}'":
    refreshonly => true,
    path        => '/bin',
    command     => "sort -o ${file} ${file}",
  }
}
