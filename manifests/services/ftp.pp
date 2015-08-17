define dcache::services::ftp {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}