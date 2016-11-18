define dcache::domain (
  $properties = {},
) {
  
  $domain_template = '[<%= $title %>]
<% each(sort(keys($properties))) |$k| { -%>
  <%= $k %> = <%= $properties[$k] %>
<% } %>'
  
  concat::fragment { $title:
    content => inline_epp($domain_template),
    target  => $dcache::layout_path,
  } -> Concat::Fragment <| tag == $title |>
}