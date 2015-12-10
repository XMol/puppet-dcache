# Define default parameters for a dCache installation.
class dcache::params {
  $experiment = $::experiment # Coming from Foreman host group.
  case $experiment {
    'urprod': {
      $headnode = 'dcacheh1'
      $hosts_service_chimera       = 'dcachepnfs'
      $hosts_service_srm           = 'dcachesrm'
      $hosts_service_httpd         = 'dcachesrm'
      $hosts_service_billing       = "$headnode"
      $hosts_service_broker        = "$headnode"
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
      $hosts_service_billing       = "$headnode"
      $hosts_service_broker        = "$headnode"
      $hosts_database_chimera      = "dc${experiment}pnfsdb"
      $hosts_database_srm          = "dc${experiment}srmdb"
      $hosts_database_spacemanager = "dc${experiment}srmdb"
      $hosts_database_pinmanager   = "dc${experiment}srmdb"
    }
  }
  
  $manage_yum_repo = true
  
  $dcache_env = '/etc/dcache.env'
  $dcache_paths_etc = '/etc/dcache'
  $dcache_layout_dir = "$dcache_paths_etc/layouts"
  $dcache_paths_admin = "$dcache_paths_etc/admin"
  $dcache_paths_setup = "$dcache_paths_etc/dcache.conf"
  $dcache_paths_config = '/var/lib/dcache/config'
  $dcache_paths_gridsecurity = '/etc/grid-security'
  $dcache_paths_plugins = '/usr/share/dcache/plugins'
  $service_exec_orig = '/etc/rc.d/init.d/dcache-server'
  $service_exec = '/etc/rc.d/init.d/dcache'
  $dcache_user = 'dcache'
  $dcache_uid = 500
  $dcache_group = 'dcache'
  $dcache_gid = 600
  $poolbasedir = '/export'
  $poolmanager_conf = "$dcache_paths_config/poolmanager.conf"
  $admin_authorized_keys = "$dcache_paths_admin/authorized_keys2"
  $gplazma_conf = "$dcache_paths_etc/gplazma.conf"
  $authzdb_file = "$dcache_paths_gridsecurity/storage-authzdb"
  $gridmap_file = "$dcache_paths_gridsecurity/grid-mapfile"
  $kpwd_file = "$dcache_paths_etc/dcache.kpwd"
  $vorolemap_file = "$dcache_paths_gridsecurity/grid-vorolemap"
  $dcache_hostcert = "$dcache_paths_gridsecurity/dcache/hostcert.pem"
  $dcache_hostkey = "$dcache_paths_gridsecurity/dcache/hostkey.pem"
  $infoprovider_tapeinfo = "$dcache_paths_etc/tape-info.xml"
  $infoprovider_xml = "$dcache_paths_etc/info-provider.xml"
  $linkgroupauthconf = "$dcache_paths_etc/LinkGroupAuthorization.conf"
  
  # Configuration parameters going into dcache.conf.
  $setup = {
    'admin.paths.authorized-keys' => "$admin_authorized_keys",
    'billing.text.format.door-request-info-message' => '$date$ [$cellType$:$cellName$:$type$] [$pnfsid$,$filesize$] [$path$] $if(storage)$$$$storage.storageClass$@$storage.hsm$$$$else$<Unknown>$endif$ $transactionTime$ $queuingTime$ ["$owner$":$uid$:$gid$:$client$] {$rc$:"$message$"}',
    'billing.text.format.mover-info-message' => '$date$ [$cellType$:$cellName$:$type$] [$pnfsid$,$filesize$] [$path$] $if(storage)$$$$storage.storageClass$@$storage.hsm$$$$else$<Unknown>$endif$ $transferred$ $connectionTime$ $created$ {$protocol$} [$initiator$] [p2p=$p2p$] {$rc$:"$message$"}',
    'chimera.db.host' => "$hosts_database_chimera",
    'cleaner.enable.hsm' => 'false',
    'dcache.authn.hostcert.key' => "$dcache_hostkey",
    'dcache.authn.hostcert.cert' => "$dcache_hostcert",
    'dcache.broker.host' => "$hosts_service_broker",
    'dcache.enable.overwrite' => 'false',
    'dcache.enable.space-reservation' => 'false',
    'dcache.user' => "$dcache_user",
    'dcache.group' => "$dcache_group",
    'dcap.authz.anonymous-operations' => 'READONLY',
    'dcap.authz.readonly' => 'true',
    'dcap.limits.clients' => '"-1"',
    'dcap.mover.queue' => 'dcapq',
    'ftp.authn.protocol' => 'gsi',
    'ftp.limits.retries' => '3',
    'ftp.limits.clients' => '"-1"',
    'ftp.mover.queue' => 'gridftpq',
    'ftp.performance-marker-period' => '10',
    'ftp.root' => '/',
    'gplazma.configuration.file' => "$gplazma_conf",
    'gplazma.authzdb.file' => "$authzdb_file",
    'gplazma.gridmap.file' => "$gridmap_file",
    'gplazma.kpwd.file' => "$kpwd_file",
    'gplazma.vorolemap.file' => "$vorolemap_file",
    'httpd.enable.authn' => 'true',
    'httpd.authz.admin-gid' => "$dcache_gid",
    'httpd.html.dcache-instance-name' => '${info-provider.se-unique-id}',
    'httpd.html.dcache-instance-description' => '${info-provider.se-unique-id}',
    'info-provider.site-unique-id' => 'FZK-LCG2',
    'info-provider.se-unique-id' => 'NEEDS CHANGE!',
    'info-provider.glue-se-status' => 'Closed',
    'info-provider.dcache-quality-level' => 'development',
    'info-provider.dcache-architecture' => 'disk',
    'info-provider.paths.tape-info' => "$infoprovider_tapeinfo",
    'info-provider.http.host' => "$hosts_service_httpd",
    'info-provider.configuration.site-specific.location' => "$infoprovider_xml",
    'nfs.mover.queue' => 'nfsq',
    'pinmanager.db.host' => "$hosts_database_pinmanager",
    'pinmanager.db.name' => 'dcache',
    'pnfsmanager.default-retention-policy' => 'REPLICA',
    'pnfsmanager.default-access-latency' => 'ONLINE',
    'poolmanager.setup.file' => "$poolmanager_conf",
    'pool.path' => "$poolbasedir/\${pool.name}",
    'pool.wait-for-files' => '${pool.path}/data',
    'pool.plugins.meta' => 'org.dcache.pool.repository.meta.db.BerkeleyDBMetaDataRepository',
    'pool.queues' => '${dcap.mover.queue},${ftp.mover.queue},${xrootd.mover.queue},${webdav.mover.queue}',
    'spacemanager.authz.link-group-file-name' => "$linkgroupauthconf",
    'spacemanager.db.host' => "$hosts_database_spacemanager",
    'spacemanager.db.name' => 'dcache',
    'srm.db.host' => "$hosts_database_srm",
    'srm.db.name' => 'dcache',
    'srm.enable.pin-online-files' => 'false',
    'transfermanagers.mover.queue' => '${ftp.mover.queue}',
    'webdav.authz.allowed-paths' => '/pnfs/gridka.de/ops:/pnfs/gridka.de/dteam',
    'webdav.authz.anonymous-operations' => 'READONLY',
    'webdav.authn.protocol' => 'https-jglobus',
    'webdav.authn.require-client-cert' => 'true',
    'webdav.mover.queue' => 'httpq',
    'xrootd.mover.queue' => 'xrootdq',
  }
}
