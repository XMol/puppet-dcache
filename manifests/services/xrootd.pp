define dcache::services::xrootd {
  # Nothing to do as of now. Later maybe import dCache plugins
  # based on $::experiment.
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}