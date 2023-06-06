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
  Dcache::Gplazma::Authzdb $authzdb = {},
  Dcache::Gplazma::Banfile $banfile = { 'bans' => [] },
  Dcache::Gplazma::Gridmap $gridmap = [],
  Dcache::Gplazma::Kpwd $kpwd = { 'version' => 2.1, },
  Dcache::Gplazma::Gridmap $vorolemap = [],
  Dcache::Gplazma::Multimap $multimap = {},
  Dcache::Layout::Properties $properties = {},
) {
  require dcache::install


  file {
    # The gplazma.conf is tricky to be managed by Augeas or template and
    # defining it in YAML style does not save effort anyway.
    lookup('dcache::setup."gplazma.configuration.file"', Stdlib::Unixpath):
      content => $gplazma,
    ;
    lookup('dcache::setup."gplazma.authzdb.file"', Stdlib::Unixpath):
      content => epp("${module_name}/gPlazma/authzdb.epp", { content => $authzdb, }),
    ;
    lookup('dcache::setup."gplazma.banfile.path"', Stdlib::Unixpath):
      content => epp("${module_name}/gPlazma/banfile.epp", { content => $banfile, }),
    ;
    lookup('dcache::setup."gplazma.gridmap.file"', Stdlib::Unixpath):
      content => epp("${module_name}/gPlazma/gridmapfile.epp", { content => $gridmap, }),
    ;
    lookup('dcache::setup."gplazma.kpwd.file"', Stdlib::Unixpath):
      content => epp("${module_name}/gPlazma/kpwd.epp", { content => $kpwd, }),
    ;
    lookup('dcache::setup."gplazma.multimap.file"', Stdlib::Unixpath):
      content => epp("${module_name}/gPlazma/multimap.epp", { content => $multimap, }),
    ;
    lookup('dcache::setup."gplazma.vorolemap.file"', Stdlib::Unixpath):
      content => epp("${module_name}/gPlazma/gridmapfile.epp", { content => $vorolemap, }),
    ;
  }

  dcache::services::generic { $title:
    domain     => $domain,
    service    => 'gplazma',
    properties => $properties,
  }
}
