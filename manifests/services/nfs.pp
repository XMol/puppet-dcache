# @summary Add the nfs service to the layout file and manage the exports file.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties of this service instance.
# @param exports
#   The export rules for dCache.
#
define dcache::services::nfs (
  String[1] $domain,
  Hash[Stdlib::Absolutepath, Hash[String[1], Array[String[1]]]] $exports,
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install

  augeas { 'Manage dCache NFS exports':
    incl    => lookup('dcache::setup."nfs.export.file"', Stdlib::Unixpath),
    lens    => 'Exports.lns',
    changes => flatten(map($exports) |$dir, $clients| {[
      "defnode dir dir[. = '${dir}'] '${dir}'",
      map($clients) |$client, $options| {[
        "defnode client \$dir/client[. = '${client}'] '${client}'",
        map($options) |$opt| {
          "set \$client/option[. = '${opt}'] '${opt}'"
        }
      ]}
    ]}),
  }

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'nfs',
    properties => $properties,
  }
}
