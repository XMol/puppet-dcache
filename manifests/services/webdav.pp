define dcache::services::webdav {
  # Nothing to do.
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}