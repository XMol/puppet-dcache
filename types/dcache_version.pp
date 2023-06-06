# @summary Which version specifiers are allowed.
type Dcache::Dcache_version = Variant[
  Pattern[/^\d+\.\d+\.\d+([[:alnum:]_.-]+)?$/],
  Enum['installed', 'present', 'absent'],
]
