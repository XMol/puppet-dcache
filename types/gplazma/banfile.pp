# @summary The banfile may contain aliases and bans as simple mappings.
#
# @example Hiera style
#   dcache::layout:
#     gplazmaDomain:
#       gplazma:
#         banfile:
#           bans:
#             - dn: /CN=Bad Person
#             - dn: /CN=His Accomplice
#
# @example Puppet style
#   dcache::domain { 'gplazmaDomain':
#     services => {
#       'gplazma' => {
#         'banfile' => [
#           { 'dn' => '/CN=Bad Person', },
#           { 'dn' => '/CN=His Accomplice', },
#         ],
#       },
#     },
#   }
#
type Dcache::Gplazma::Banfile = Struct[{
  Optional['aliases'] => Hash[String, String],
  'bans'              => Array[Hash[String, String, 1, 1]],
}]
