# @summary Create the layout file with header.
#
# @api private
#
# @note
#   Actual content after the header is added by the `dcache::domain`
#   and `dcache::service::*` resource types.
#
class dcache::layout () {
  require dcache::install

  $layout_dir = lookup('dcache::setup."dcache.layout.dir"', Stdlib::Unixpath)
  $layout_path = "${layout_dir}/${::hostname}.conf"
  concat { $layout_path:
    owner          => $dcache::user,
    group          => $dcache::group,
    ensure_newline => true,
    warn           => true,
  }

  Concat::Fragment {
    target => $layout_path,
  }

  $layout_properties = filter($dcache::layout) |$k, $v| { $v =~ Scalar }
  unless(empty($layout_properties)) {
    concat::fragment { 'Global layout settings':
      order   => '05',
      content => inline_epp(@(EOT)),
        <% each($layout_properties) |$k, $v| { -%>
        <%= $k %> = <%= $v %>
        <% } -%>

        | EOT
    }
  }

  $domains = filter($dcache::layout) |$k, $v| {
    $v =~ Dcache::Layout::Domain
  }
  each($domains) |$domain, $parameters| {
    dcache::domain { $domain:
      properties => filter($parameters) |$k, $v| { $v =~ Scalar },
      services   => filter($parameters) |$k, $v| { $v =~ Dcache::Layout::Service }
    }
  }
}
