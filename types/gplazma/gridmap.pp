# @summary Validate the lines for the grid-mapfile of gPlazma.
type Dcache::Gplazma::Gridmap = Array[
  Struct[
    dn              => String[1],
    Optional[fqan]  => String[1],
    login           => String[1],
  ]
]
