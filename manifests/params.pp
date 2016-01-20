# Define default parameters for a dCache installation.
# These parameters are at some point needed by Puppet, but should be optional
# settings for end users. In other words, set a couple of parameters
# with dCache's default values, so Puppet knows them.
class dcache::params {
  $paths_etc = '/etc/dcache'
  $paths_admin = "$paths_etc/admin"
  $paths_config = '/var/lib/dcache/config'
  $paths_gridsecurity = '/etc/grid-security'
  $env = '/etc/dcache.env'
  $setup = "$paths_etc/dcache.conf"
  $layout = "$paths_etc/layouts/$::hostname.conf"
  $user = 'dcache'
  $group = 'dcache'
  $poolmanager = "$paths_config/poolmanager.conf"
  $authorized_keys = "$paths_admin/authorized_keys2"
  $gplazma = "$paths_etc/gplazma.conf"
  $authzdb = "$paths_gridsecurity/storage-authzdb"
  $gridmap = "$paths_gridsecurity/grid-mapfile"
  $kpwd = "$paths_etc/dcache.kpwd"
  $vorolemap = "$paths_gridsecurity/grid-vorolemap"
  $tapeinfo = "$paths_etc/tape-info.xml"
  $infoprovider = "$paths_etc/info-provider.xml"
  $linkgroupauth = "$paths_etc/LinkGroupAuthorization.conf"
}
