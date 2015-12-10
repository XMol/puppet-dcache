class dcache::java (
  $package = $dcache::java_package,
) {

  package { 'Java4dCache' :
    name   => "$package",
  }

}