# Define a generic dCache service, that does nothing special,
# just add a line to the layouts file and possibly add
# some properties. Ie. no dedicated configuration file need to
# be managed.
define dcache::services::generic (
  $domain,
  $service = $title,
  $layout_path = $dcache::layout_path,
  $properties = {},
) {
  require dcache
  
  $service_template = '[<%= $domain %>/<%= $service %>]
<% each(sort(keys($properties))) |$k| { -%>
  <%= $k %> = <%= $properties[$k] %>
<% } %>'
  
  concat::fragment { "${domain}/${service}":
    content => inline_epp($service_template),
    target  => $layout_path,
  }
}