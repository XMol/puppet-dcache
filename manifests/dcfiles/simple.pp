define dcache::dcfiles::simple (
  $file,
  $augeas,
) {

  augeas { "Manage '${file}' with Augeas":
    incl    => $file,
    lens    => 'Simplevars.lns',
    changes => map($augeas) |$k, $v| { "set '${k}' '${v}'" },
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
