define dcache::services::info {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}