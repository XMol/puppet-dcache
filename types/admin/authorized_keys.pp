# @summary The authorized ssh keys for accessing the dCache administration interface.
type Dcache::Admin::Authorized_keys = Hash[
  String[1],
  Struct[{
    Optional['name'] => NotUndef[String[1]],
    'ensure'         => Optional[Enum['present', 'absent']],
    'key'            => NotUndef[String[1]],
    'options'        => Optional[Array[Pattern[/^\w+=.+$/]]],
    'provider'       => Optional['parsed'],
    'target'         => Optional[Stdlib::Absolutepath],
    'user'           => Optional[Variant[String[1], Integer[0]]],
    'type'           => Optional[Enum[
      'ssh-dss', 'ssh-rsa',
      'ecdsa-sha2-nistp256', 'ecdsa-sha2-nistp384', 'ecdsa-sha2-nistp521',
      'ssh-ed25519', 'dsa', 'ed25519', 'rsa',
    ]],
  }]
]
