class dcache (
  $dcache_version,
  $java_package = $dcache::params::java_package,
  $experiment = $dcache::params::experiment,
  $manage_yum_repo = $dcache::params::manage_yum_repo,
  
  $domains = $dcache::params::domains,
  $plugins = $dcache::params::plugins,
  
  $chimera_db_host      = $dcache::params::chimera_db_host,
  $chimera_db_name      = $dcache::params::chimera_db_name,
  $chimera_db_user      = $dcache::params::chimera_db_user,
  $srm_db_host          = $dcache::params::srm_db_host,
  $srm_db_name          = $dcache::params::srm_db_name,
  $srm_db_user          = $dcache::params::srm_db_user,
  $spacemanager_db_host = $dcache::params::spacemanager_db_host,
  $spacemanager_db_name = $dcache::params::spacemanager_db_name,
  $spacemanager_db_user = $dcache::params::spacemanager_db_user,
  $pinmanager_db_host   = $dcache::params::pinmanager_db_host,
  $pinmanager_db_name   = $dcache::params::pinmanager_db_name,
  $pinmanager_db_user   = $dcache::params::pinmanager_db_user,
  
  $billing_text_format_door_request_info_message = $dcache::params::billing_text_format_door_request_info_message,
  $billing_text_format_mover_info_message        = $dcache::params::billing_text_format_mover_info_message,
  
  $broker_host = $dcache::params::broker_host,
  
  $cleaner_enable_hsm = $dcache::params::cleaner_enable_hsm,
  
  $dcache_user                     = $dcache::params::dcache_user,
  $dcache_group                    = $dcache::params::dcache_group,
  $dcache_layout                   = $dcache::params::dcache_layout,
  $dcache_dirs_layout              = $dcache::params::dcache_dirs_layout,
  $dcache_dirs_etc                 = $dcache::params::dcache_dirs_etc,
  $dcache_dirs_plugins             = $dcache::params::dcache_dirs_plugins,
  $dcache_env                      = $dcache::params::dcache_env,
  $dcache_setup                    = $dcache::params::dcache_setup,
  $admin_paths_authorized_key      = $dcache::params::admin_paths_authorized_key,
  $dcache_authn_hostcert_key       = $dcache::params::dcache_authn_hostcert_key,
  $dcache_authn_hostcert_cert      = $dcache::params::dcache_authn_hostcert_cert,
  $dcache_enable_overwrite         = $dcache::params::dcache_enable_overwrite,
  $dcache_enable_space_reservation = $dcache::params::dcache_enable_space_reservation,
  $dcache_java_memory_heap         = $dcache::params::dcache_java_memory_heap,

  $dcap_authz_anonymous_operations = $dcache::params::dcap_authz_anonymous_operations,
  $dcap_authz_readonly             = $dcache::params::dcap_authz_readonly,
  $dcap_mover_queue                = $dcache::params::dcap_mover_queue,
  $dcap_limits_clients             = $dcache::params::dcap_limits_clients,
  
  $ftp_performance_marker_period = $dcache::params::ftp_performance_marker_period,
  $ftp_mover_queue               = $dcache::params::ftp_mover_queue,
  $ftp_limits_clients            = $dcache::params::ftp_limits_clients,
  $ftp_limits_retries            = $dcache::params::ftp_limits_retries,
  $ftp_authn_protocol            = $dcache::params::ftp_authn_protocol,
  
  $gplazma_configuration_file = $dcache::params::gplazma_configuration_file,
  $gplazma_gridmap_file       = $dcache::params::gplazma_gridmap_file,
  $gplazma_authzdb_file       = $dcache::params::gplazma_authzdb_file,
  $gplazma_vorolemap_file     = $dcache::params::gplazma_vorolemap_file,
  $gplazma_kpwd_file          = $dcache::params::gplazma_kpwd_file,
  
  $httpd_enable_authn                     = $dcache::params::httpd_enable_authn,
  $httpd_authz_admin_gid                  = $dcache::params::httpd_authz_admin_gid,
  $httpd_html_dcache_instance_name        = $dcache::params::httpd_html_dcache_instance_name,
  $httpd_html_dcache_instance_description = $dcache::params::httpd_html_dcache_instance_description,
  
  $info_provider_site_unique_id                       = $dcache::params::info_provider_site_unique_id,
  $info_provider_se_unique_id                         = $dcache::params::info_provider_se_unique_id,
  $info_provider_glue_se_status                       = $dcache::params::info_provider_glue_se_status,
  $info_provider_dcache_quality_level                 = $dcache::params::info_provider_dcache_quality_level,
  $info_provider_dcache_architecture                  = $dcache::params::info_provider_dcache_architecture,
  $info_provider_paths_tape_info                      = $dcache::params::info_provider_paths_tape_info,
  $info_provider_configuration_site_specific_location = $dcache::params::info_provider_configuration_site_specific_location,
  $info_provider_http_host                            = $dcache::params::info_provider_http_host,
  
  $nfs_mover_queue = $dcache::params::nfs_mover_queue,
  $nfs_version     = $dcache::params::nfs_version,
  
  $pnfsmanager_default_retention_policy          = $dcache::params::pnfsmanager_default_retention_policy,
  $pnfsmanager_default_access_latency            = $dcache::params::pnfsmanager_default_access_latency,
  $pnfsmanager_enable_full_path_permission_check = $dcache::params::pnfsmanager_enable_full_path_permission_check,

  $poolmanager_setup_file = $dcache::params::poolmanager_setup_file,
  
  $poolbasedir               = $dcache::params::poolbasedir,
  $pool_path                 = $dcache::params::pool_path,
  $pool_wait_for_files       = $dcache::params::pool_wait_for_files,
  $pool_queues               = $dcache::params::pool_queues,
  $pool_plugins_meta         = $dcache::params::pool_plugins_meta,
  $pool_mover_xrootd_plugins = $dcache::params::pool_mover_xrootd_plugins,
  
  $spacemanager_enable_unreserved_uploads_to_linkgroups = $dcache::params::spacemanager_enable_unreserved_uploads_to_linkgroups,
  $spacemanager_authz_link_group_file_name              = $dcache::params::spacemanager_authz_link_group_file_name,
  
  $srm_enable_pin_online_files = $dcache::params::srm_enable_pin_online_files,
  $srm_net_host                = $dcache::params::srm_net_host,
  
  $transfermanagers_mover_queue = $dcache::params::transfermanagers_mover_queue,
  
  $webdav_authz_allowed_paths        = $dcache::params::webdav_authz_allowed_paths,
  $webdav_authz_anonymous_operations = $dcache::params::webdav_authz_anonymous_operations,
  $webdav_authn_protocol             = $dcache::params::webdav_authn_protocol,
  $webdav_authn_require_client_cert  = $dcache::params::webdav_authn_require_client_cert,
  $webdav_mover_queue                = $dcache::params::webdav_mover_queue,
  
  $xrootd_mover_queue = $dcache::params::xrootd_mover_queue,
  $xrootd_plugins     = $dcache::params::xrootd_plugins,  
  
) inherits dcache::params {
  
  contain dcache::install
  contain dcache::config
  
}
