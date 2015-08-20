define dcache::services::xrootd {
  # Nothing to do as of now. Later maybe import dCache plugins
  # based on $::experiment.
  if $dcache::debug { notify { "realized $title":  } }
}