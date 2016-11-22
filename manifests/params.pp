# Define default parameters for a dCache installation.
# These parameters are at some point needed by Puppet, but should be optional
# settings for end users. In other words, set a couple of parameters
# with dCache's default values, so Puppet knows them.
class dcache::params {
  $paths_etc = '/etc/dcache'
  $paths_admin = "${paths_etc}/admin"
  $paths_billing = '/var/lib/dcache/billing'
  $paths_config = '/var/lib/dcache/config'
  $paths_lib = '/var/lib/dcache'
  $paths_log = '/var/log/dcache'
  $paths_gridsecurity = '/etc/grid-security'
  $env_path = '/etc/dcache.env'
  $setup_path = "${paths_etc}/dcache.conf"
  $layout_path = "${paths_etc}/layouts/${::hostname}.conf"
  $user = 'dcache'
  $group = 'dcache'
  $poolmanager_path = "${paths_config}/poolmanager.conf"
  $authorized_keys_path = "${paths_admin}/authorized_keys2"
  $gplazma_path = "${paths_etc}/gplazma.conf"
  $authzdb_path = "${paths_gridsecurity}/storage-authzdb"
  $gridmap_path = "${paths_gridsecurity}/grid-mapfile"
  $kpwd_path = "${paths_etc}/dcache.kpwd"
  $vorolemap_path = "${paths_gridsecurity}/grid-vorolemap"
  $tapeinfo_path = "${paths_etc}/tape-info.xml"
  $infoprovider_path = "${paths_etc}/info-provider.xml"
  $linkgroupauth_path = "${paths_etc}/LinkGroupAuthorization.conf"
  $exports_path = '/etc/exports'
}
