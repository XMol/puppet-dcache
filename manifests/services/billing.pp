define dcache::services::billing {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}