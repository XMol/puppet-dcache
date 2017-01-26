# info-provider isn't actually a real dCache service, but there
# are related configuration files for the BDII, which are managed
# here.
# Both configuration files are supposed to be XML files, which
# are best managed by sourcing them from somewhere.
define dcache::services::infoprovider (
  $infoprovider = '',
  $tapeinfo = '',
) {
  require dcache
  
  File {
    owner => $dcache::user,
    group => $dcache::group,
  }
  
  if $tapeinfo != '' {
    file { $dcache::tapeinfo_path:
      source => $tapeinfo,
    }
  }
  
  if $infoprovider != '' {
    file { $dcache::infoprovider_path:
      source => $infoprovider,
    }
  }
}