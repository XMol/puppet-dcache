# Example for using the `dcache` module with Hiera
The focus during development of the `dcache` module was made such that
parameterization through an ENC would allow for easy transfer of current
configurations. In some case, like the PoolManager configuration, using
this module should even be less error prone and more user friendly than
editing the final configuration file manually.

Throughout this example, YAML code syntax is used, since that is the most
common use case for Hiera together with Puppet. Furthermore we assume the
following hierarchy configured for Hiera (from bottom to top):
1. `common.yaml` provides the most basic configuration.
1. `midrange.yaml` serves as an intermediate layer, for which there can
   be any number, selected by any criteria that suits your needs.
1. `hostname.yaml` is the most specific, since it is based on a node's
   host name.

## Common layer
In this layer one wants to put in everything that should be configured for
any dCache node. Of course, the same parameters can be overruled on
higher Hiera priority levels.

```yaml
classes:
  - dcache

dcache::version: 2.16
dcache::user: dcadmin
dcache::group: middleware
```

* Naturally, for every dCache node, the `dcache` module will be assigned.
  The module itself is designed such that no other class should be
  assigned to any node directly.
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
dcache::setup:
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

* Simply list every property and their respective value as key-value-pairs
  and they will go into 'dcache.conf' verbatim.
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
actual services to be offered by dCache. Note that domains and services are
resources in Puppet and those cannot be managed through Hiera directly.
You might need a conversion class like `puppet_type_wrapper` in this example.

```yaml
dcache::layout_globals:
  dcache.java.memory.heap: 512m

puppet_type_wrapper::specs:
  dcache::domain:
    &srmDomain "srm-${host.name}Domain":
      properties:
        dcache.java.memory.heap: 8g
    &gplazmaDomain gplazmaDomain: {}
  dcache::services::gplazma:
    domain: *gplazmaDomain
    gplazma: |+
      auth optional x509
      auth sufficient voms
      auth optional kpwd
      
      map sufficient kpwd
      map optional vorolemap
      map optional authzdb
      
      session sufficient kpwd
      session optional authzdb
  dcache::services::generic:
    srm:
      domain: *srmDomain
      properties:
        srm.db.host: localhost
    spacemanager:
      domain: *srmDomain
```

* On this node, we want to apply 'dcache.java.memory.heap' to all dCache
  domains.
* We create two domains: "srm-${host.name}Domain" and "gplazmaDomain".
  + The "srm-${host.name}Domain" is allowed to use more memory for
    its Java heap space.
* Set up three services, only gplazma makes use of the specialized
  resource type `dcache::services::gplazma`. There is also one for
  spacemanager, but we opt to not configure the 'LinkGroupAuthroization.conf'
  file here, which would be required.
* Instead of redefining the entire `dcache.conf` content, we set `srm.db.host`
  as an property to the srm service.
  + It is very important to understand that several occurences of any
    parameter in Hiera will **not** get **merged**!

