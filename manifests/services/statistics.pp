define dcache::services::statistics {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}