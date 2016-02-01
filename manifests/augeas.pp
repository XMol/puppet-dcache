# Put the dCache specific Augeas lenses from this Puppet module in
# the default Augeas search path.
class dcache::augeas (
  $augeas_include_dir = '/usr/share/augeas/lenses',
) {
  each(['dcachelayout.aug', 'gridmapfile.aug', 'poolmanager.aug',
        'kpwd.aug', 'linkgroupauthorization.aug', 'storageauthzdb.aug']) |$f| {
    file { "$augeas_include_dir/$f":
      source => "puppet:///modules/$module_name/$f",
      require => Package['augeas'],
    }
  }
}