define dcache::services::httpd {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}