# Define default parameters for a dCache installation.
class dcache::params inherits dcache::globals {
  $experiment      = $dcache::globals::experiment
  $manage_yum_repo = $dcache::globals::manage_yum_repo
  
  $domains = []
  $plugins = []
  
  $chimera_db_host      = $dcache::globals::hosts_database_chimera
  $chimera_db_name      = 'chimera'
  $chimera_db_user      = $dcache::globals::dcache_user
  $srm_db_host          = $dcache::globals::hosts_database_srm
  $srm_db_name          = 'dcache'
  $srm_db_user          = $dcache::globals::dcache_user
  $spacemanager_db_host = $dcache::globals::hosts_database_srm
  $spacemanager_db_name = 'srm'
  $spacemanager_db_user = $dcache::globals::dcache_user
  $pinmanager_db_host   = $dcache::globals::hosts_database_pinmanager
  $pinmanager_db_name   = 'srm'
  $pinmanager_db_user   = $dcache::globals::dcache_user
  
  $billing_text_format_door_request_info_message = '$date$ [$cellType$:$cellName$:$type$] [$pnfsid$,$filesize$] [$path$] $if(storage)$$$$storage.storageClass$@$storage.hsm$$$$else$<Unknown>$endif$ $transactionTime$ $queuingTime$ ["$owner$":$uid$:$gid$:$client$] {$rc$:"$message$"}'
  $billing_text_format_mover_info_message        = '$date$ [$cellType$:$cellName$:$type$] [$pnfsid$,$filesize$] [$path$] $if(storage)$$$$storage.storageClass$@$storage.hsm$$$$else$<Unknown>$endif$ $transferred$ $connectionTime$ $created$ {$protocol$} [$initiator$] [p2p=$p2p$] {$rc$:"$message$"}'
  
  $broker_host = 'localhost'
  
  $cleaner_enable_hsm = false
  
  $dcache_user                     = $dcache::globals::dcache_user
  $dcache_group                    = $dcache::globals::dcache_group
  $dcache_layout                   = "$::fqdn"
  $dcache_dirs_layout              = "${dcache::globals::dcache_dirs_etc}/layouts"
  $dcache_dirs_etc                 = "${dcache::globals::dcache_dirs_etc}"
  $dcache_dirs_plugins             = '/usr/share/dcache/plguins'
  $dcache_env                      = '/etc/dcache.env'
  $dcache_setup                    = "${dcache::globals::dcache_dirs_etc}/dcache.conf"
  $admin_paths_authorized_key      = "${dcache::globals::dcache_dirs_etc}/admin/authorized_keys2"
  $dcache_authn_hostcert_key       = "${dcache::globals::dcache_dirs_grid_security}/dcache/hostkey.pem"
  $dcache_authn_hostcert_cert      = "${dcache::globals::dcache_dirs_grid_security}/dcache/hostcert.pem"
  $dcache_enable_overwrite         = false
  $dcache_enable_space_reservation = false
  $dcache_java_memory_heap         = undef

  $dcap_authz_anonymous_operations = 'NONE'
  $dcap_authz_readonly             = true
  $dcap_mover_queue                = 'dcapq'
  $dcap_limits_clients             = '-1'
  
  $ftp_performance_marker_period = 10
  $ftp_mover_queue               = 'gridftpq'
  $ftp_limits_clients            = '-1'
  $ftp_limits_retries            = '3'
  $ftp_authn_protocol            = 'gsi'
  
  $gplazma_configuration_file = "${dcache::globals::dcache_dirs_etc}/gplazma.conf"
  $gplazma_gridmap_file       = "${dcache::globals::dcache_dirs_grid_security}/grid-mapfile"
  $gplazma_authzdb_file       = "${dcache::globals::dcache_dirs_grid_security}/storage_authzdb"
  $gplazma_vorolemap_file     = "${dcache::globals::dcache_dirs_grid_security}/grid-vorolemap"
  $gplazma_kpwd_file          = "${dcache::globals::dcache_dirs_etc}/dcache.kpwd"
  
  $httpd_enable_authn                     = true
  $httpd_authz_admin_gid                  = 600
  $httpd_html_dcache_instance_name        = 'My dCache'
  $httpd_html_dcache_instance_description = 'A dCache setup with default description.'
  
  $info_provider_site_unique_id                       = 'FZK_LCG2'
  $info_provider_se_unique_id                         = 'UNKNOWNVALUE'
  $info_provider_glue_se_status                       = 'Closed'
  $info_provider_dcache_quality_level                 = 'development'
  $info_provider_dcache_architecture                  = 'tape'
  $info_provider_paths_tape_info                      = "${dcache::globals::dcache_dirs_etc}/tape_info.xml"
  $info_provider_configuration_site_specific_location = "${dcache::globals::dcache_dirs_etc}/info-provider.xml"
  $info_provider_http_host                            = $dcache::globals::hosts_service_httpd
  
  $nfs_mover_queue = 'nfsq'
  $nfs_version     = '3,4.1'
  
  $pnfsmanager_default_retention_policy          = 'REPLICA'
  $pnfsmanager_default_access_latency            = 'ONLINE'
  $pnfsmanager_enable_full_path_permission_check = false

  $poolmanager_setup_file = '/var/lib/dcache/config'
  
  $poolbasedir               = $dcache::globals::poolbasedir
  $pool_path                 = "${dcache::globals::poolbasedir}/\${pool.name}"
  $pool_wait_for_files       = '${pool.path}/data'
  $pool_queues               = 'dcapq,gridftpq,httpq,nfsq,xrootdq'
  $pool_plugins_meta         = 'org.dcache.pool.repository.meta.db.BerkeleyDBMetaDataRepository'
  $pool_mover_xrootd_plugins = undef
  
  $spacemanager_enable_unreserved_uploads_to_linkgroups = false
  $spacemanager_authz_link_group_file_name              = "${dcache::globals::dcache_dirs_etc}/LinkGroupAuthorization_conf"
  
  $srm_enable_pin_online_files = false
  $srm_net_host                = $dcache::globals::hosts_service_srm
  
  $transfermanagers_mover_queue = 'gridftpq'
  
  $webdav_authz_allowed_paths        = ['/pnfs/gridka.de/ops', '/pnfs/gridka.de/dteam']
  $webdav_authz_anonymous_operations = 'READONLY'
  $webdav_authn_protocol             = 'https-jglobus'
  $webdav_authn_require_client_cert  = true
  $webdav_mover_queue                = 'httpq'
  
  $xrootd_mover_queue = 'xrootdq'
  $xrootd_plugins     = undef
  
  case "${::osfamily}:${::operatingsystemmajrelease}" {
    'RedHat:6': { $java_package = 'java-1.8.0-openjdk-1.8.0.51' }
    default:    { $java_package = 'jdk1.8.0_45' }
  }
}