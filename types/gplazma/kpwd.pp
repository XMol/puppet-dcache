# @summary Validate the content of the dcache.kpwd file of gPlazma.
type Dcache::Gplazma::Kpwd = Struct[{
  'version'            => Variant[Enum['2.0', '2.1'], Float[2.0, 2.1]],
  Optional['mappings'] => Hash[String[1], String[1]],
  Optional['logins']   =>
    Hash[
      String[1],
      Struct[{
        NotUndef['access'] => Enum['read-only', 'read-write'],
        NotUndef['uid']    => Integer[0],
        NotUndef['gid']    => Integer[0],
        NotUndef['home']   => Stdlib::Absolutepath,
        NotUndef['root']   => Stdlib::Absolutepath,
        Optional['extra']  => Stdlib::Absolutepath,
        NotUndef['dns']    => Array[String[1]],
      }]
    ],
  Optional['passwds']  =>
    Hash[
      String[1],
      Struct[{
        NotUndef['pwdhash'] => String[8, 8],
        NotUndef['access']  => Enum['read-only', 'read-write'],
        NotUndef['uid']     => Integer[0],
        NotUndef['gid']     => Integer[0],
        NotUndef['home']    => Stdlib::Absolutepath,
        NotUndef['root']    => Stdlib::Absolutepath,
        Optional['extra']   => Stdlib::Absolutepath,
      }]
    ],
}]
