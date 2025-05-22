# @summary Validate the content of the multi-mapfile of gPlazma.
type Dcache::Gplazma::Multimap = Hash[
  Pattern[/\A(dn|email|entitlement|fqan|gid|group|kerberos|oidc|oidcgrp|op|uid|username):/],
  Hash[
    Enum[
      'dn',
      'email',
      'entitlement',
      'fqan',
      'gid',
      'group',
      'kerberos',
      'oidc',
      'oidcgrp',
      'op',
      'roles',
      'uid',
      'username'
    ],
    Variant[Integer, String]
  ]
]
