# @summary Deploy files for the "info-based info-provider".
#
# @note
#   dCache has no info-provider service, but a feature, which requires
#   supplementary information not kept in the `dcache.conf` or layout files.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param infoprovider
#   The source Puppet can synchronize the info-provider.xml from.
# @param tapeinfo
#   The source Puppet can synchronize the tape-info.xml from.
#
define dcache::services::infoprovider (
  Optional[String] $domain = undef,
  Optional[Stdlib::Filesource] $infoprovider = undef,
  Optional[Stdlib::Filesource] $tapeinfo = undef,
) {
  require dcache::install


  if $tapeinfo {
    file { lookup('dcache::setup."info-provider.paths.tape-info"', Stdlib::Unixpath):
      source => $tapeinfo,
    }
  }

  if $infoprovider {
    file { lookup('dcache::setup."info-provider.configuration.site-specific.location"', Stdlib::Unixpath):
      source => $infoprovider,
    }
  }
}
