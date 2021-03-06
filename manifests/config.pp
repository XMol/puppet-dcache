# This class will manage the dcache.env file and dcache.conf.
# Other configuration files are managed by the respective
# service resource types. The layout file will get its
# global settings here, but domains and services are coming
# from the resource types.
class dcache::config (
  $user = $dcache::user,
  $group = $dcache::group,
  $env = $dcache::env,
  $setup_path = $dcache::setup_path,
  $setup = $dcache::setup,
  $layout_path = $dcache::layout_path,
  $layout_globals = $dcache::layout_globals,
) {
  require dcache
  File {
    owner => $user,
    group => $group,
  }
  
  file { $dcache::params::paths_env:
    content => epp('dcache/simple.epp', { content => $env, }),
  }

  file { $setup_path:
    content => epp('dcache/simple.epp', { content => $setup, }),
  }

  concat { $layout_path:
    owner => $user,
    group => $group,
  }
  
  concat::fragment { 'dCache layout header':
    target  => $layout_path,
    order   => '05',
    content => epp('dcache/simple.epp', { content => $layout_globals, }),
  }
}