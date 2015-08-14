class dcache::globals {
  $experiment = $::experiment
  case $experiment {
    'urprod': {
      $headnode = 'dcacheh1'
      $hosts_service_chimera     = 'dcachepnfs'
      $hosts_service_srm         = 'dcachesrm'
      $hosts_service_httpd       = 'dcachesrm'
      $hosts_service_billing     = 'dcacheh1'
      $hosts_service_broker      = 'dcacheh1'
      $hosts_database_chimera    = 'dcachesrm'
      $hosts_database_srm        = 'dcachesrm'
      $hosts_database_pinmanager = 'dcachesrm'
    }
    default: {
      $headnode                  = "dc${experiment}h1"
      $hosts_service_chimera     = "dc${experiment}pnfs"
      $hosts_service_srm         = "dc${experiment}srm"
      $hosts_service_httpd       = "dc${experiment}srm"
      $hosts_service_billing     = "dc${experiment}h1"
      $hosts_service_broker      = "dc${experiment}h1"
      $hosts_database_srm        = "dc${experiment}srm"
      $hosts_database_pinmanager = "dc${experiment}srm"
      $hosts_database_chimera    = "dc${experiment}srm"
    }
  }
  
  $manage_yum_repo = true
  
  
  $dcache_user               = 'dcache'
  $dcache_dirs_etc           = '/etc/dcache'
  $dcache_dirs_grid_security = '/etc/grid-security'
  $poolbasedir               = '/export'
}