# @summary Add the webdav service to the layout and manage `.well-known` resources.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties for this service instance.
#
define dcache::services::webdav (
  String[1] $domain,
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install
  include dcache::wlcg_tape_rest_api

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'webdav',
    properties => $properties,
  }
}
