class dcache::java ($package) {
  package { 'Java4dCache' :
    name   => "$package",
    ensure => installed,
  }~>
  # Only when a new Java package was installed should /etc/dcache.env
  # be updated.
  exec { '/etc/dcache.env: JAVA_HOME':
    refreshonly => true,
    command     => "dirname $(dirname $(rpm -ql ${package} | sed -n '\\+bin/java$+ s/.*/JAVA_HOME=&/ p')) >${title}",
    path        => '/bin',
  }~>
  exec { '/etc/dcache.env: JAVA':
    refreshonly => true,
    command     => "rpm -ql ${package} | sed -n '\\+bin/java$+ s/.*/JAVA_HOME=&/ p' >>${title}",
    path        => '/bin',
  }
}