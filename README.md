# Puppet Module `dcache`
Install dCache using this module.

## Requisites and dependencies
### Java
dCache is a Java program and thus requires Java to be installed. This module
though neither installs it, nor does it raise any dependency on installed
Java packages or declared Puppet resources.

### Database
Some dCache services require a RDBMS backend, traditionally a PostgreSQL
instance. Installing Postgres is _not_ part of this module. Instead,
there is a well developed public Puppet module supported by Puppetlabs
for managing PostgreSQL installations: [puppetlabs-postgresql](https://github.com/puppetlabs/puppetlabs-postgresql).

## Parameters
This module is service oriented using defined types for domains and dCache
services. Hence, the module itself only exposes parameters to change global
settings like paths to configuration files and the content for the dcache.env
and dcache.conf files as well as a section to be included in any layout file.
<ul>
  <li><b><code>version</code></b><br />
    The only mandatory parameter, which must indicate the (full) desired
    dCache version (e.g. '2.13.43').
  </li>
  <li><code>user = <i>dcache</i></code>, <code>group = <i>dcache</i></code><br />
    <code>user</code>, <code>group</code> may be set respectively to change
    the user and group for running dCache's processes. Note that the dCache
    rpm will create a 'dcache' user and group account in any case.
    This class will not create the user or group in case they don't exist yet
    on the system. The reason for this is, that Puppet cannot manage the same
    resource in different places in parallel and we don't want to interfere
    with other user management facilities.
  </li>
  <li><code>env = <i>{}</i></code><br />
    Using this parameter, environment variables (like `JAVA_HOME` and `JAVA`)
    can be set for dCache processes.
  </li>
  <li><code>setup = <i>{}</i></code><br />
    Similar to `$env`, a hash of properties will be written into dCache's
    central configuration file (dcache.conf).
  </li>
  <li><code>layout_globals = <i>{}</i></code><br />
    Here one may specify properties that are to be included in all layout
    files throughout the dCache setup.
  </li>
  <li><code>poolmanager_path = <i>/var/lib/dcache/config/poolmanager.conf</i></code><br />
    The fully qualified path to the configuration file of the poolmanager service.
  </li>
  <li><code>authorized_keys_path = <i>/etc/dcache/admin/authorized_keys</i></code><br />
    The fully qualified path to the authorized_keys file used by the admin service.
  </li>
  <li><code>gplazma_path = <i>/etc/dcache/gplazma.conf</i></code><br />
    The fully qualified path to the configuration file of the gplazma service.
  </li>
  <li><code>authzdb_path = <i>/etc/grid-security/authzdb</i></code><br />
    The fully qualified path to the authzdb file, used by gplazma.
  </li>
  <li><code>gridmap_path = <i>/etc/grid-security/grid-mapfile</i></code><br />
    The fully qualified path to the gridmap file, used by gplazma.
  </li>
  <li><code>vorolemap_path = <i>/etc/grid-security/grid-vorolemap</i></code><br />
    The fully qualified path to the vorolemap file, used by gplazma.
  </li>
  <li><code>kpwd_path = <i>/etc/dcache/dcache.kpwd</i></code><br />
    The fully qualified path to the kpwd file, used by gplazma.
  </li>
  <li><code>tapeinfo_path = <i>/etc/dcache/tape-info.xml</i></code><br />
    The fully qualified path to the tape-info.xml file, used by the info service.
  </li>
  <li><code>infoprovider_path = <i>/etc/dcache/info-provider.xml</i></code><br />
    The fully qualified path to the info-provider.xml file, used by the info service.
  </li>
  <li><code>exports_path = <i>/etc/exports</i></code><br />
    The fully qualified path to the exports file, used by the nfs service.
  </li>
  <li><code>linkgroupauth_path = <i>/etc/dcache/LinkGroupAuthorization.conf</i></code><br />
    The fully qualified path to the configuration file of the linkgroupauth_path service.
  </li>
</ul>
Note that, if you deviate from the default paths here, you will have to
include the appropriate property in the dcache.conf or layout file, too, to
make dCache aware of it - this module does not take care of that!

## Resource types
This module provides the `domain` and `services::generic`
resource types to manage the layout of the dCache services. For a couple of
services there are specialized resource types, which allow administrators to
manage related configuration files at the same time.

Because explaining the available resource types and how to utilize them
would expand this document by a lot, it was [seperated](resource_types.md).

## dCache as a service
This module does not define dCache as a service. The main reason is, that
a running state is not precisely defined, when the service is split over
independent processes, ie. domains. Maybe in the future we will define
the individual domains as a service on operating system level (code
contribution is welcome).

## Examples
Examples can be found in [file_struct_def](file_struct_def.md) for configuration files.

Since this module is designed with an
[ENC](https://www.google.de/#q=puppet%20external%20node%20classifier)
in mind, there is an example for how to apply this module with Hiera-yaml files
in Hiera_Example.md.
