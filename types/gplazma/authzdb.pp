# @summary Validate content of the storage-authzdb for gPlazma.
type Dcache::Gplazma::Authzdb = Hash[
  String[1],
  Variant[
    Enum['2.0', '2.1'],
    Float[2.0, 2.1],
    Struct[{
      NotUndef['access'] => Enum['read-only', 'read-write'],
      NotUndef['uid']    => Integer[0],
      NotUndef['gids']   => Array[Integer[0]],
      NotUndef['home']   => Stdlib::Absolutepath,
      NotUndef['root']   => Stdlib::Absolutepath,
      Optional['extra']  => Stdlib::Absolutepath,
    }]
  ]
]
