# @summary Define a generic dCache service in the layout file.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties of this service instance.
# @param service
#   Which service needs to be configured.
#
define dcache::services::generic (
  String[1] $domain,
  String[1] $service = $title,
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install

  concat::fragment { "${domain}/${service}":
    content => inline_epp(@(EOT)),
      [<%= $domain %>/<%= $service %>]
      <% each($properties) |$k, $v| { -%>
        <%= $k %> = <%= $v %>
      <% } -%>
      | EOT
  }
}
