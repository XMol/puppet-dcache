define dcache::dcfiles::authkeys (
  $file,
  $augeas,
) {
  create_resources('ssh_authorized_key', $augeas, { target => $file, user => $dcache::user })
}
