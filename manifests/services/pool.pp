define dcache::services::pool (
  $basedir    = $dcache::poolbasedir,
  $filesystem,
) {
  file { "Symlink pool ${name}":
    ensure => link,
    path   => "${basedir}/${name}",
    target => "${filesystem}/{$name}",
  }
  
  # Ensure GPFS mount.
  # Ensure pool directory (wait-for-files!) exists.
}