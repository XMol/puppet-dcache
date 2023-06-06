# @summary Manage the `dcache.env` and `dcache.conf` files.
#
# @api private
#
# @note
#   Other configuration files are managed by the respective service resource types.
#
class dcache::config () {
  require dcache::install

  file {
    '/etc/dcache.env':
      content => inline_epp(@(EOT)),
        # Managed by Puppet.
        # Any modifications will be gone with the next Puppet synchronization!

        <% each($dcache::env) |$k, $v| { -%>
        <%= $k %> = <%= $v %>
        <% } %>
        | EOT
    ;
    lookup('dcache::setup."dcache.paths.setup"', Stdlib::Unixpath):
      content => inline_epp(@(EOT)),
        # Managed by Puppet.
        # Any modifications will be gone with the next Puppet synchronization!

        <% each($dcache::setup) |$k, $v| { -%>
        <%= $k %> = <%= $v %>
        <% } %>
        | EOT
    ;
  }
}
