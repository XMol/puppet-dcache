# @summary Add the SRM Space Manager service to the layout and manage `LinkGroupAuthorization.conf`.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties for this service instance.
# @param linkgroupauth
#   The data for `LinkGroupAuthorization.conf`.
#
define dcache::services::spacemanager (
  String[1] $domain,
  Hash[String[1], Array[String[1]]] $linkgroupauth,
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install

  file { lookup('dcache::setup."spacemanager.authz.link-group-file-name"', Stdlib::Unixpath):
    owner   => $dcache::user,
    group   => $dcache::group,
    content => epp('dcache/SpaceManager/linkgroupauth.epp', { content => $linkgroupauth, }),
  }

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'spacemanager',
    properties => $properties,
  }
}
