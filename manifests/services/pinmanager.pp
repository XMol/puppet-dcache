define dcache::services::pinmanager {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}