define dcache::services::srm {
  # Do nothing...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}