define dcache::domain (
  $options  = [],
  $services = []
) {
  # Realize every service resource, so we can carry out service specific
  # changes.
  dcache::service { "$services": }

}

define dcache::service {
  class { "dcache::services::${name}": }
}