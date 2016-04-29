define dcache::dcfiles::authkeys (
  $file,
  $augeas,
) {
  # We have to ensure $file is owned by $dcache::user, otherwise
  # ssh_authorized_key will fail updating it.
  file { "Ensure right owner of '${file}'":
    owner => $dcache::user,
  }
  
  create_resources('ssh_authorized_key', $augeas, { target => $file, user => $dcache::user })
}
