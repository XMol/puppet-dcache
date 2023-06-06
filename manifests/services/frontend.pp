# @summary Add the frontend service to the layout and manage `.well-known` resources.
#
# @api private
#
# @see https://securitytxt.org/
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties for this service instance.
# @param security_txt
#   The verbatim content of the `security.txt` file.
#   Verbatim, because otherwise it is impossible to accept digitally signed content.
#
define dcache::services::frontend (
  String[1] $domain,
  String $security_txt,
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install
  include dcache::wlcg_tape_rest_api

  $httpd_path = lookup('dcache::setup."dcache.paths.httpd"', Stdlib::Unixpath)
  file { "${httpd_path}/security.txt":
    owner   => $dcache::user,
    group   => $dcache::group,
    content => $security_txt,
  }

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'frontend',
    properties => $properties,
  }
}
