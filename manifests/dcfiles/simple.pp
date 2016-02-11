define dcache::dcfiles::simple (
  $file,
  $augeas,
) {

  augeas { "Manage '$file' with Augeas":
    incl => "$file",
    lens => 'Simplevars.lns',
    changes => map($augeas) |$k, $v| { "set '$k' '$v'" },
  }

}