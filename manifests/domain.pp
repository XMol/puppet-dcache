# @summary Add a dCache domain to the layout file.
#
# @api private
#
# @param properties
#   The properties of this domain.
# @param services
#   The services of this domain
#
define dcache::domain (
  Dcache::Layout::Properties $properties = {},
  Hash[String[1], Dcache::Layout::Service] $services = {},
) {
  require dcache::install

  concat::fragment { $title:
    content => inline_epp(@(EOT)),
      
      [<%= $title %>]
      <% each($properties) |$k, $v| { -%>
        <%= $k %> = <%= $properties[$k] %>
      <% } -%>
      | EOT
  }

  each($services) |$service, $data| {
    # For services, we cannot distinct properties from parameters by
    # filtering for Scalar values anymore. Unless $service is known
    # as a resource type, we declare a generic service resource.
    $r = "dcache::services::${service}"
    if defined($r) {
      create_resources($r,
        { "${title}/${service}" => $data, },
        { 'domain' => $title, }
      )
    }
    # Check whether we're declaring a pool resource. Only for those we
    # support taking $service as designated cell name.
    elsif 'service' in $data and $data['service'] == 'pool' {
      create_resources('dcache::services::pool',
        { $service => $data - 'service', },
        { 'domain' => $title, }
      )
    } else {
      create_resources('dcache::services::generic',
        { "${title}/${service}" => $data, },
        { 'domain' => $title, 'service' => $service, }
      )
    }
  }
}
