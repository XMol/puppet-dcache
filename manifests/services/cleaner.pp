define dcache::services::cleaner {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}