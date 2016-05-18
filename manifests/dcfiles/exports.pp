define dcache::dcfiles::exports (
  $file,
  $augeas,
) {

  augeas { "Manage '${file}' with Augeas":
    incl    => $file,
    lens    => 'Exports.lns',
    changes => flatten(map($augeas) |$dir, $clients| {[
      "defnode dir dir[. = '${dir}'] '${dir}'",
      map($clients) |$client, $options| {[
        "defnode client \$dir/client[. = '${client}'] '${client}'",
        map($options) |$opt| {
          "set \$client/option[. = '${opt}'] '${opt}'"
        }
      ]}
    ]}),
  }
}
