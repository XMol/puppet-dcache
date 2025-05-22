# @summary Define all data for the gPlazma service.
#
# @api private
#
# @param domain
#   The domain this service is hosted by.
# @param properties
#   The properties of this service instance.
# @param gplazma
#   The verbatim content of `gplazma.conf`.
# @param authzdb
#   The structured data for maintaining storage-authzdb.
# @param banfile
#   The structured data for maintainaing a banfile.
# @param gridmap
#   The structured data for maintaining grid-mapfile.
# @param kpwd
#   The structured data for maintaining dcache.kpwd.
# @param vorolemap
#   The structured data for maintaining grid-vorolemap.
# @param multimap
#   The structured data for maintaining multi-mapfile.
#
define dcache::services::gplazma (
  String[1] $domain,
  String[1] $gplazma,
  Dcache::Layout::Properties $properties = {},
  Optional[Dcache::Gplazma::Authzdb] $authzdb = undef,
  Dcache::Gplazma::Banfile $banfile = { 'bans' => [], },
  Optional[Dcache::Gplazma::Gridmap] $gridmap = undef,
  Optional[Dcache::Gplazma::Kpwd] $kpwd = undef,
  Optional[Dcache::Gplazma::Gridmap] $vorolemap = undef,
  Optional[Dcache::Gplazma::Multimap] $multimap = undef,
) {
  require dcache::install

  # Check whether a cell specific property was set as new path to a config file
  $gplazma_conf_path_property = 'gplazma.configuration.file'
  $gplazma_conf_path = pick(
    lookup("dcache::layout.\"${domain}\".gplazma.properties.\"${gplazma_conf_path_property}\"", Variant[Stdlib::Unixpath, Undef], 'first', undef),
    lookup("dcache::setup.\"${gplazma_conf_path_property}\"", Stdlib::Unixpath)
  )
  $authzdb_path_property = 'gplazma.authzdb.file'
  $authzdb_path = pick(
    lookup("dcache::layout.\"${domain}\".gplazma.properties.\"${authzdb_path_property}\"", Variant[Stdlib::Unixpath, Undef], 'first', undef),
    lookup("dcache::setup.\"${authzdb_path_property}\"", Stdlib::Unixpath)
  )
  $banfile_path_property = 'gplazma.banfile.path'
  $banfile_path = pick(
    lookup("dcache::layout.\"${domain}\".gplazma.properties.\"${banfile_path_property}\"", Variant[Stdlib::Unixpath, Undef], 'first', undef),
    lookup("dcache::setup.\"${banfile_path_property}\"", Stdlib::Unixpath)
  )
  $gridmap_path_property = 'gplazma.gridmap.file'
  $gridmap_path = pick(
    lookup("dcache::layout.\"${domain}\".gplazma.properties.\"${gridmap_path_property}\"", Variant[Stdlib::Unixpath, Undef], 'first', undef),
    lookup("dcache::setup.\"${gridmap_path_property}\"", Stdlib::Unixpath)
  )
  $kpwd_path_property = 'gplazma.kpwd.file'
  $kpwd_path = pick(
    lookup("dcache::layout.\"${domain}\".gplazma.properties.\"${kpwd_path_property}\"", Variant[Stdlib::Unixpath, Undef], 'first', undef),
    lookup("dcache::setup.\"${kpwd_path_property}\"", Stdlib::Unixpath)
  )
  $multimap_path_property = 'gplazma.multimap.file'
  $multimap_path = pick(
    lookup("dcache::layout.\"${domain}\".gplazma.properties.\"${multimap_path_property}\"", Variant[Stdlib::Unixpath, Undef], 'first', undef),
    lookup("dcache::setup.\"${multimap_path_property}\"", Stdlib::Unixpath)
  )
  $vorolemap_path_property = 'gplazma.vorolemap.file'
  $vorolemap_path = pick(
    lookup("dcache::layout.\"${domain}\".gplazma.properties.\"${vorolemap_path_property}\"", Variant[Stdlib::Unixpath, Undef], 'first', undef),
    lookup("dcache::setup.\"${vorolemap_path_property}\"", Stdlib::Unixpath)
  )

  file {
    # The gplazma.conf is tricky to be managed by Augeas or template and
    # defining it in YAML style does not save effort anyway.
    $gplazma_conf_path:
      content => $gplazma,
    ;
    $authzdb_path:
      ensure  => bool2str($authzdb =~ Undef, 'absent', 'present'),
      content => epp("${module_name}/gPlazma/authzdb.epp", { content => pick($authzdb, {}), }),
    ;
    $banfile_path:
      content => epp("${module_name}/gPlazma/banfile.epp", { content => $banfile, }),
    ;
    $gridmap_path:
      ensure  => bool2str($gridmap =~ Undef, 'absent', 'present'),
      content => epp("${module_name}/gPlazma/gridmapfile.epp", { content => pick($gridmap, []), }),
    ;
    $kpwd_path:
      ensure  => bool2str($kpwd =~ Undef, 'absent', 'present'),
      content => epp("${module_name}/gPlazma/kpwd.epp", { content => pick($kpwd, { 'version' => 2.1, }), }),
    ;
    $multimap_path:
      ensure  => bool2str($multimap =~ Undef, 'absent', 'present'),
      content => epp("${module_name}/gPlazma/multimap.epp", { content => pick($multimap, {}), }),
    ;
    $vorolemap_path:
      ensure  => bool2str($vorolemap =~ Undef, 'absent', 'present'),
      content => epp("${module_name}/gPlazma/gridmapfile.epp", { content => pick($vorolemap, []), }),
    ;
  }

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'gplazma',
    properties => $properties,
  }
}
