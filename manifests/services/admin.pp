# @summary Add the admin service to the layout and deploy ssh authorized keys for it.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties of this service instance.
# @param authorized_keys
#   The authorized ssh keys to access this admin service instance.
#
define dcache::services::admin (
  String $domain,
  Dcache::Admin::Authorized_keys $authorized_keys,
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install


  create_resources('ssh_authorized_key',
    $authorized_keys,
    {
      target => lookup("dcache::setup.'admin.paths.authorized-keys'", Stdlib::Unixpath),
      user   => $dcache::user,
    }
  )

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'admin',
    properties => $properties,
  }
}
