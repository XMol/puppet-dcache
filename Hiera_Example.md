# Example for using the `dcache` module with Hiera
The focus during development of the `dcache` module was made such that
parameterization through an ENC would allow for easy transfer of current
configurations. In some case, like the PoolManager configuration, using
this module should even be less error prone and more user friendly than
editing the final configuration file manually.

Throughout this example, yaml code syntax is used, since that is the most
common use case for Hiera together with Puppet. Furthermore we assume the
following hierarchy configured for Hiera (from bottom to top):
1. `common.yaml` provides the most basic configuration.
1. `midrange.yaml` serves as an intermediate layer, for which there can
   be any number, selected by any criteria that suits your needs.
1. `hostname.yaml` is the most specific, since it is based on a node's
   host name.

## Common layer
In this layer one wants to put in everything that should be configured for
any dCache node. Of course, the same parameters can be overruled in
higher Hiera priority levels.
```yaml
classes:
  - dcache

dcache::version: 2.16
dcache::user: dcadmin
dcache::group: middleware
```
* Naturally, for every dCache node, the `dcache` module will be assigned.
  The module itself is designed such that no other class or resource of it
  should be assigned to any node directly.
* The only mandatory `version` parameter is set here. Though the possibility
  to override it in later stages is highly advisable.
* In case you want to have a different user or group name for running dCache,
  setting it here is the best place for a uniform setup.

## Midrange layer
Midrange may contain any number of layers, based on any criteria for node
selection you can think of. Though this doesn't mean there have to be any
midrange layers at all. Having none and only operate with the common
and host layer is perfectly fine as well. That said, the most management
flexebility, versatility and power steams from having many hierarchy layers.
For example, your site possibly supports different communities,
you might want to distinct for them. Having a separation for dCache headnodes,
door nodes and pool nodes might come in handy, too. And, most obviously, if
there are more than one independent dCache instances, those are a natural
borderline for configuration management.

In general, here is the ideal place to put the content of the central
`dcache.conf` file!
```yaml
dcache::setup_augeas:
  srm.db.host: dcache_srm
  dcache.broker.host: dcache_headnode
  dcache.enable.overwrite: false
  dcache.user: dcadmin
  info-provider.site-unique-id: %{site_name}
  info-provider.se-unique-id: &se_uniq hiera-demo.example.org
  httpd.html.dcache-instance-name: *se_uniq
  pool.wait-for-files: "${pool.path}/data"
  pool.path: "/mnt/${pool.name}"
```
* Here we chose to manage `dcache.conf` with Augeas.
* Simply list every property and their respective value as key-value-pairs.
* Even though `dcache::user` was set in the common layer, that has _no
  effect_ on the dCache property! Hence the property `dcache.user` must still
  be set explicitly.
* Insert values coming from Hiera/Puppet, e.g. the name of your site.
* It is perfectly fine to use the YAML style of backreferences to earlier
  values. This will increase maintainability by reducing duplicate settings.
* Note that it is still possible to exploit dCache's own hierarchical
  configuration structure. Quoted strings will be written to the configuration
  files as they are and dCache will interpret them.

## Host-specific layer
Lastly, the host-specific layer should be the right choice for defining the
content of dCache's layout files.
```yaml
dcache::layout_template:
  properties:
    dcache.java.memory.heap: 512m
    srm.db.host: localhost
  "srm-${host.name}Domain":
    properties:
      dcache.java.memory.heap: 8g
    services:
      - spacemanager
      - srm
  gplazmaDomain:
    services:
      - gplazma
```
* This time we decided to employ a template for managing the layout file.
* Instead of redefining the entire `dcache.conf` content, just to alter
  the value of `srm.db.host`, we include it as a new dCache property in the
  layout file.
** It is very important to understand that several occurences of any
   parameter in Hiera will **not** get **merged**!

## Service-oriented configuration management
dCache knows a number of other configuration files, that are evaluated
by specific dCache services. It doesn't really matter in which layer those
are defined, as long as they actually are present for those nodes that
have to host the respective services. So it would be possible to define
the content of `poolmanager.conf` in the common layer already and Puppet
then will ensure that `poolmanager.conf` exists on every dCache node. That
will cause no trouble at all, since only the PoolManager service will read
it.
