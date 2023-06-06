# @summary Deploy wlcg-tape-rest-api.json with WebDAV and/or Frontend services.
#
# @api private
#
# @param endpoints
#   The details on where the Frontend service and the REST APi are to be found.
#
# @example Basic Hiera example
#   dcache::wlcg_tape_rest_api::endpoints:
#     sitename: "%{lookup('dcache::setup.\"info-provider.se-unique-id\"')}"
#     endpoints:
#       - uri: "https://%{lookup('dCache frontend FQDN')}:3880/api/v1/tape"
#         version: v1
#         metadata:
#           quality-level: pre-production
#
class dcache::wlcg_tape_rest_api (
  Optional[Dcache::Wlcg_tape_api] $endpoints = undef,
) {
  require dcache

  if $endpoints {
    $httpd_path = lookup('dcache::setup."dcache.paths.httpd"', Stdlib::Unixpath)
    file { "${httpd_path}/wlcg-tape-rest-api.json":
      owner   => $dcache::user,
      group   => $dcache::group,
      content => to_json_pretty($endpoints),
    }
  }
}
