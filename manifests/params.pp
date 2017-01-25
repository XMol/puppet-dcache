# Define default parameters for a dCache installation.
# These parameters are at some point needed by Puppet, but should be optional
# settings for end users. In other words, set a couple of parameters
# with dCache's default values, so Puppet knows them.
class dcache::params {
  $user = 'dcache'
  $group = 'dcache'
  $paths_etc = '/etc/dcache'
  $paths_setup = "${paths_etc}/dcache.conf"
  $paths_layout = "${paths_etc}/layouts/${::hostname}.conf"
  $paths_admin = "${paths_etc}/admin"
  $paths_lib = '/var/lib/dcache'
  $paths_billing = "${paths_lib}/billing"
  $paths_config = "${paths_lib}/config"
  $paths_log = '/var/log/dcache'
  $paths_gridsecurity = '/etc/grid-security'
  $paths_env = '/etc/dcache.env'
  $paths_pm = "${paths_config}/poolmanager.conf"
  $paths_authkeys = "${paths_admin}/authorized_keys2"
  $paths_gplazma = "${paths_etc}/gplazma.conf"
  $paths_authzdb = "${paths_gridsecurity}/storage-authzdb"
  $paths_gridmap = "${paths_gridsecurity}/grid-mapfile"
  $paths_kpwd = "${paths_etc}/dcache.kpwd"
  $paths_vorolemap = "${paths_gridsecurity}/grid-vorolemap"
  $paths_tapeinfo = "${paths_etc}/tape-info.xml"
  $paths_infoprovider = "${paths_etc}/info-provider.xml"
  $paths_lgauth = "${paths_etc}/LinkGroupAuthorization.conf"
  $paths_exports = '/etc/exports'
}
