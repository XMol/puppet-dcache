# @summary Defines the domains and services the layout on this node comprises of.
type Dcache::Layout = Hash[
  String[1], # Property name or domain title
  Variant[
    Scalar, # Property value
    Dcache::Layout::Domain
  ]
]
