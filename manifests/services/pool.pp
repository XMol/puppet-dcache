define dcache::services::pool (
  $basedir    = $dcache::poolbasedir,
  $filesystem,
) {
  
  ensure_resource ('file', 'Symlink directory',
    {
      ensure => directory,
      path   => "${basedir}",
    }
  )
  
  file { "Symlink pool ${name}":
    ensure  => link,
    path    => "${basedir}/${name}",
    target  => "${filesystem}/${name}",
  }
  
  # Ensure GPFS mount.
  # Ensure pool directory (wait-for-files!) exists.

  if $dcache::debug { notify { "realized $title":  } }
}