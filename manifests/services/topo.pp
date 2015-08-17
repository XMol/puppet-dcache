define dcache::services::topo {
  # No need to do anything here...
  notify { 'Dummy notification':
    message => "realized ${module_name}",
  }
}