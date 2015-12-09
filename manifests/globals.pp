class dcache::globals {
  $experiment = $::experiment
  case $experiment {
    'urprod': {
      $headnode = 'dcacheh1'
      $hosts_service_chimera       = 'dcachepnfs'
      $hosts_service_srm           = 'dcachesrm'
      $hosts_service_httpd         = 'dcachesrm'
      $hosts_service_billing       = 'dcacheh1'
      $hosts_service_broker        = 'dcacheh1'
      $hosts_database_chimera      = 'dcachepnfsdb'
      $hosts_database_srm          = 'dcachesrmdb'
      $hosts_database_spacemanager = 'dcachesrmdb'
      $hosts_database_pinmanager   = 'dcachesrmdb'
    }
    default: {
      $headnode                    = "dc${experiment}h1"
      $hosts_service_chimera       = "dc${experiment}pnfs"
      $hosts_service_srm           = "dc${experiment}srm"
      $hosts_service_httpd         = "dc${experiment}gplazma"
      $hosts_service_billing       = "dc${experiment}h1"
      $hosts_service_broker        = "dc${experiment}h1"
      $hosts_database_chimera      = "dc${experiment}pnfsdb"
      $hosts_database_srm          = "dc${experiment}srmdb"
      $hosts_database_spacemanager = "dc${experiment}srmdb"
      $hosts_database_pinmanager   = "dc${experiment}srmdb"
    }
  }
  
  $manage_yum_repo = true
  
  $dcache_user               = 'dcache'
  $dcache_group              = 'dcache'
  $poolbasedir               = '/export'
}