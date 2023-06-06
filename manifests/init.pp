# @summary Maintain a dCache installation.
#
# @see https://www.dcache.org
#
# @example Hiera example of a crippled setup for simplicity's sake
#   classes:
#     - dcache
#   dcache::setup:
#     dcache.zookeeper.connection: zookeeper.example.org:2181/
#   dcache::layout:
#     # Global layout property mappings have Scalar values
#     dcache.java.memory.heap: 500m
#     # dCache domains have mapping values
#     dCacheDomain:
#       # Domain properties have Scalar values
#       dcache.broker.scheme: core
#       # Services have mapping values
#       nfs:
#         # Service properties need to be grouped with the 'properties' key
#         properties:
#           nfs.version: 3
#         # Depending on the service type, there may be additional
#         # supported parameters. Refer to ./dcache_services.md
#         # for the entire documentation.
#         exports:
#           /pnfs:
#             localhost:
#               - rw
#               - no_root_squash
#       # dcache::services::pinmanager is _not_ a known Puppet resource.
#       # So Puppet will translate this data into a dcache::services::generic
#       # resource.
#       pinmanager: {}
#     poolDomain:
#       # Only for pools, we support setting its designated name in this way
#       pool_1:
#         service: pool
#         size: 200000000000
#       pool_2:
#         service: pool
#         size: 200000000000
#
# @param version
#   The only mandatory parameter specifies the desired semantic version of dCache.
# @param user
#   The designated uid of the dCache configuration files and service processes.
# @param group
#   The designated primary gid of the dCache configuration files and service processes.
# @param env
#   Using this parameter, environment variables (like `JAVA_HOME` and `JAVA`)
#   can be set globally for dCache.
# @param setup
#   Similar to `env`, a hash of properties will be written into dCache's
#   central configuration file (`dcache.conf`).
# @param layout
#   The complete layout of dCache domains and services (of the current node).
#
# @note
#   The dCache rpm&mdash;as shipped by dCache.org&mdash; will
#   ensure a "dcache" user and group account exists in any case.  
#   This module will _not_ attempt to manage either, in
#   order to not interfere with other user management facilities.
# @note
#  This module relies on discoverable package sources in order to install
#  the dCache rpms. It will not configure any source repositories.
#
class dcache (
  Dcache::Dcache_version $version,
  Hash[String[1], Scalar] $setup,
  Dcache::Layout $layout,
  Variant[String[1], Integer[0]] $user = 'dcache',
  Variant[String[1], Integer[0]] $group = 'dcache',
  Hash[String[1], Scalar] $env = {},
) {
  File {
    owner => $user,
    group => $group,
  }

  class { 'dcache::install': }
    -> class { 'dcache::config': }
      -> class { 'dcache::layout': }
}
