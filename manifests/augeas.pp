# Put the dCache specific Augeas lenses from this Puppet module in
# the default Augeas search path.
class dcache::augeas (
  $augeas_include_dir = '/usr/share/augeas/lenses',
) {
  $dcache_aug_lenses = [
    'dcachelayout.aug', 'gridmapfile.aug', 'poolmanager.aug',
    'kpwd.aug', 'linkgroupauthorization.aug', 'storageauthzdb.aug',
  ]
  file { $dcache_aug_lenses:
    path => "$augeas_include_dir/$title",
    source => "puppet:///modules/$module_name/$title",
    require => Package['augeas'],
  }
}