define dcache::services::pnfsmanager {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}