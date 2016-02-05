# Puppet Module `dcache`
Install dCache using this class.

## Requisites and dependencies
### Java
Running dCache has a dependency to install Java, which is why this class will
install Java in any case. Though one can specify the exact Java package to
be installed using the parameter `$java_package`.
### Database
Some dCache services require a RDBMS backend, traditionally a PostgreSQL
instance. Installing Postgres is _not_ part of this class. One needs to
include `dcache-postgresql` explicitly.
### Parameters
The only parameter that is mandatory for using this class is
`$dcache_version`, which needs to be the exact version number desired
for installation. There are many additional parameters, that may be set
on top level, but there are too many to list them all here. Most of them
are directly related to settings indcache.conf, inspectinit.pp for exact list
of supported parameters (subject to change, see #1). Note that this class has
two stages of parameter evaluation _before_
<span style="font-family:monospace;">init.pp</span>!
1. [globals.pp](#global-parameters)
2. [params.pp](#further-parameters)

All parameters introduced by either of those classes may be overwritten
with class `dcache`, though there is some conditional logic done by them
and the final result may turn out wrong if not set at the right stage.


#### Global parameters
The single most important global parameter for this module is
**```$experiment```**. With this parameter, many settings are sorted out automatically
(in [class params](#further-parameters)), so they don't need to be set explicitly
anymore. E.g. our internal host aliases are preconfigured based on the value
to ```$experiment```. Further parameters include...
<ul>
  <li><code>$manage_yum_repo</code> = <i>true|false (default: true)</i><br />
    Whether class dcache should manage the yum repository files for
    installation of dCache.
  </li>

  <li><code>$dcache_user</code>, <code>$dcache_group</code> = <i>any string (default: 'dcache')</i><br />
    The name of the user account for running dCache.<br />
    :warning: Installation might break if this is not the default.
  </li>

  <li><code>$dcache_dirs_etc</code> = <i>any fully qualified path (default: '/etc/dcache')</i><br />
    The default directory for most of dCache's configuration files, including
    dcache.conf.
  </li>

  <li><code>$dcache_dirs_etc</code> = <i>any fully qualified path (default: '/etc/grid-security')</i><br />
    The default directory for most of dCache's configuration files, including
    dcache.conf.
  </li>

  <li><code>$poolbasedir</code> = <i>any fully qualified path (default: '/export')</i><br />
    Here we will put symbolic links pointing towards individual dCache pool
    directories, which will be located on mounted (GPFS) file systems.
  </li>

  <li><code>$headnode</code> = <i>string (default: 'dc<code>${experiment}</code>h1')</i><br />
    The name of the node hosting the dCacheDomain.
  </li>

  <li><code>$hosts_service_*</code> = <i>string (default depends on <code>${experiment}</code>)</i><br />
    The name of the node hosting a specific service.
  </li>

  <li><code>$hosts_database_*</code> = <i>string (default depends on <code>${experiment}</code>)</i><br />
    The name of the node hosting a specific database.
  </li>
</ul>

#### Further parameters
Further parameters are introduced/set by class params. Those parameters that
are not directly related to dCache properties are...
<ul>
  <li><code>$debug</code> = <i>true|false (default: false)</i><br />
    Enable/disable debug notify resources for any of the classes from
    this module.
  </li>

  <li><code>$service_status</code> = <i>stopped|running (default: 'stopped')</i><br />
    Analogous to Puppet's ensure parameter on services.<br />Thanks to the
    default, dCache won't be started upon first installation without explicitly
    setting this parameter.
  </li>

  <li><code>$manage_service</code> = <i>true|false (default: true)</i><br />
    Should Puppet add dCache as a service to the standard service management
    facilities?
  </li>

  <li><code>$domains</code> = <i>hash (default: <code>{}</code>)</i><br />
    This parameter is used to fill in the dCache layout of a specific node;
    for more details see [## dCache layout](#dcache-layout).
  </li>

  <li><code>$plugins</code> = <i>array of strings (default: <code>[]</code>)</i><br />
    A list of plugins that should be installed for dCache.
    :bangbang: Currently not implemented. :bangbang:
  </li>

  <li><code>$java_package</code> = <i>string (default depends on OS)</i><br />
    Class params will try and set a specific Java package depending on
    the detected operating system. But using this parameter, a different
    package may be designated.
  </li>
</ul>

## dCache layout
Using this class, a lot of necessary changes for a specific node are derived
from the layout. E.g. only some supplementary configuration files
are generated, if a service depending on them is hosted on a specific node.
The layout for a node may be stated using the `$domains` parameter using this
pattern:

```yaml
# In a hiera yaml file.
dcache::domains:
  <unique domain name>Domain:
    [options:]
    services:
      <service by name>[,<unique idetifier>]:
        [options:]
        service-dependent-parameter: <value>
        service-dependent-parameter: <value>
        ...
  <unique domain name>Domain:
    ...
```

* The value to `$domains` must be a hash, where each key begins a new domain,
domain names must be unique for all dCache nodes of the same instance!
* The `options` hash is optional in itself and may be a hash of additional
settings on **domain** level for dCache. :warning: Currently not implemented;
requires automatic generation of layout files.
* `services` again is a hash, were each key introduces a new service. These
keys are used by dCache itself to identify the service to be included! Use
a comma-separated, unique identifier in case the same service has to be
included more often than once or the cell name for this service needs to be
unique across all dCache domains, e.g. for dCache pools.
* The `options` hash is optional in itself and may be a hash of additional
settings on **service** level for dCache. :warning: Currently not implemented;
requires automatic generation of layout files.
* Any number of optional or mandatory parameters to a certain service as key
value pairs.

:warning: As of now, layout files &ndash; or any other dCache configurations
file &ndash; are not generated by Puppet, but instead are sourced from a
different project (dcache_config).:warning:

### Example
Here we declare three independent dCache domains, the dCachedomain has
an explicit amount of Java heap usage. Note how the two pools have been
named: first the service name 'pool' and then, with a comma separated,
the name to be used for this pool.
```yaml
dcache::domains:
  dCacheDomain:
    options:
      dcache.java.memory.heap: 1g
    services:
      poolmanager:
      admin:
  srm-%{hostname}Domain:
    services:
      srm:
      spacemanager:
  poolDomain:
    services:
      pool,%{hostname}_1D_atlas:
        basedir: /export
        filesystem: gka1234
      pool,%{hostname}_2D_atlas:
        basedir: /export
        filesystem: gka1235
```