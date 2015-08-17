define dcache::services::transfermanagers {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}