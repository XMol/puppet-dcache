# @summary Validate the content of the omnisession configuration for gPlazma.
type Dcache::Gplazma::Omnisession = Hash[
  Variant[
    Pattern[/\A(dn|email|entitlement|fqan|gid|group|kerberos|oidc|oidcgrp|uid|username):/],
    Enum['DEFAULT']
  ],
  Struct[{
    Optional[read-only]  => Boolean,
    Optional[home]       => Stdlib::Unixpath,
    Optional[max-upload] => Pattern[/\A\d+(?i:[kmgtp]?i?b)\Z/],
    Optional[prefix]     => Stdlib::Unixpath,
    Optional[root]       => Stdlib::Unixpath,
  }]
]
