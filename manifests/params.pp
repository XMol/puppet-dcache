# Define default parameters for a dCache installation.
# These parameters are at some point needed by Puppet, but should be optional
# settings for end users. In other words, set a couple of parameters
# with dCache's default values, so Puppet knows them.
class dcache::params {
  $dcache_env = '/etc/dcache.env'
  $dcache_paths_etc = '/etc/dcache'
  $dcache_layout_file = "$dcache_paths_etc/layouts/$::hostname.conf"
  $dcache_paths_admin = "$dcache_paths_etc/admin"
  $dcache_paths_setup = "$dcache_paths_etc/dcache.conf"
  $dcache_paths_config = '/var/lib/dcache/config'
  $dcache_paths_gridsecurity = '/etc/grid-security'
  $dcache_paths_plugins = '/usr/share/dcache/plugins'
  $service_exec = '/etc/rc.d/init.d/dcache-server'
  $dcache_user = 'dcache'
  $dcache_group = 'dcache'
  $poolmanager_conf = "$dcache_paths_config/poolmanager.conf"
  $admin_authorized_keys = "$dcache_paths_admin/authorized_keys2"
  $gplazma_conf = "$dcache_paths_etc/gplazma.conf"
  $authzdb_file = "$dcache_paths_gridsecurity/storage-authzdb"
  $gridmap_file = "$dcache_paths_gridsecurity/grid-mapfile"
  $kpwd_file = "$dcache_paths_etc/dcache.kpwd"
  $vorolemap_file = "$dcache_paths_gridsecurity/grid-vorolemap"
  $infoprovider_tapeinfo = "$dcache_paths_etc/tape-info.xml"
  $infoprovider_xml = "$dcache_paths_etc/info-provider.xml"
  $linkgroupauthconf = "$dcache_paths_etc/LinkGroupAuthorization.conf"
}
