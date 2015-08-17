define dcache::services::nfs {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}