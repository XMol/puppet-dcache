# info-provider isn't actually a real dCache service, but there
# are related configuration files for the BDII, which are managed
# here.
# Both configuration files are supposed to be XML files, which
# are best managed by sourcing them from somewhere.
define dcache::services::infoprovider (
  $infoprovider = '',
  $tapeinfo = '',
  $tapeinfo_path = $dcache::tapeinfo_path,
  $infoprovider_path = $dcache::infoprovider_path,
) {
  require dcache
  
  File {
    owner => $dcache::user,
    group => $dcache::group,
  }
  
  if $tapeinfo != '' {
    file { $tapeinfo_path:
      source => $tapeinfo,
    }
  }
  
  if $infoprovider != '' {
    file { $infoprovider_path:
      source => $infoprovider,
    }
  }
}