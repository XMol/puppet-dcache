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
The only mandatory parameter is `version`, which must indicate the (full)
dVache version (e.g. '2.13.43').

`user` and `group` may be set respectively to change the user and group
for running dCache's processes. Note that these accounts will _not_ be created
by this module! Instead, the dCache packages will create a 'dcache' user
and group, which will be used by default.

This module provides a large number of additional parameters, though virtually
only a fraction of them are actually used. In general, there are five
parameters for each dCache configuration file: one that contains the (fully
qualified) path and up to four others, each indicating a different means for
managing the targetted file.
* `*_source`  
Source the configuration file from somewhere. This must be url that is
valid for the Puppet `file` resource type, which probably requires that
the source is accessible from the Puppet master in some way.
* `*_content`  
With this parameter the explicit content of a configuration file can be
set.
* `*_template` or `*_augeas`  
These parameters will evaluate a hash structure, specific to each configuration
file (see File_stuct_def.md), and manage the target either with a template or
by employing Augeas (which must be installed, since this module doesn't require
it at any point). The crucial difference is, that with templates the target's
content is strictly enforced, whereas with Augeas modifications and additions
can be done by system administrators (as long as they don't conflict with the
parameter, naturally). As a side effect, the templates generally generate files
that are cleaner and easier to comprehend.

These parameter sets are evaluated in the same order the are listed before
and only the first non-empty value is applied. That means, that a target
will _always_ and _only_ be sourced, when the `*_source` parameter is set, even
though other parameters might have been supplied, too. Likewise have
`*_content` parameters higher priority over `*_template`, which in turn
beat `*_augeas`. This order reflects the difficulties and risks inherent
to the respective management tool, too. Ie. sourcing a configuration file
is the most straight forward solution with the least amount of risk, but it
also provides the least flexibility. Augeas on the other hand will ensure
certain settings in the configuration files, while it also allows
administrators to add further customizations, e.g. temporary situations
like downtimes or simply to experiment.

Lastly, note that whenever the path of a configuration file is altered
with one of these parameters, only Puppet will notice it. The matching
dCache property must also be changed explicitly through either the central
configuration of the layout file!

### Manageable configuration files
These are the dCache configuration files currently manageable using this module
and their respective default paths. Details on how objects must be structed
when using `*_template` or `*_augeas` parameters are provided in
File_struct_def.md. For more documentation on what each respective
configuration file is capable of, please refer to "The dCache Book".
<ul>
  <li><code>$env</code> = <i>'/etc/dcache.env'</i><br />
    Using this file, environment variables (like `JAVA_HOME` and `JAVA`) can be
    set for dCache processes.
  </li>

  <li><code>$setup</code> = <i>'/etc/dcache/dcache.conf'</i><br />
    The central dCache configuration file.
  </li>

  <li><code>$layout</code> = <i>'/etc/dcache/layouts/${::hostname}.conf'</i><br />
    The layout file for a node.
  </li>

  <li><code>$poolmanager</code> = <i>'/var/lib/dcache/config/poolmanager.conf'</i><br />
    Provide persistent configuration to dCache's PoolManager service
    using this file.
  </li>

  <li><code>$authorized_keys</code> = <i>'/etc/dcache/admin/authorized_keys2'</i><br />
    Key management file for access to the administration interface using
    ssh.<br />
    The <code>*_template</code> variant is <b>not</b> supported!
  </li>

  <li><code>$gplazma</code> = <i>'/etc/dcache/gplazma.conf'</i><br />
    Configure the plugins for dCache's gPlazma service.<br />
    <b>Only</b> supported through <code>$gplazma_source</code> and
    <code>$gplazma_content</code>!
  </li>

  <li><code>$kpwd</code> = <i>'/etc/dcache/dcache.kpwd'</i><br />
    A dCache specific file for managing user accounts. It provides several
    methods for user recognition and mapping.
  </li>

  <li><code>$gridmap</code> = <i>'/etc/grid-security/grid-mapfile'</i><br />
    Mappings of user DN's onto user names.
  </li>

  <li><code>$vorolemap</code> = <i>'/etc/grid-security/grid-vorolemap'</i><br />
    Mappings of user DNs and/or VOMS FQANs onto user names.
  </li>

  <li><code>$authzdb</code> = <i>'/etc/grid-security/storage_authzdb'</i><br />
    Mappings of users onto uid and gid for authorization in dCache.
  </li>

  <li><code>$exports</code> = <i>'/etc/exports'</i><br />
    Manage the export of dCache's namespace via nfs.
  </li>

  <li><code>$linkgroupauth</code> = <i>'/etc/dcache/LinkGroupAuthorization.conf'</i><br />
    A dCache specific configuration file that manages which users are able
    to access certain link groups for reading and/or writing.
  </li>

  <li><code>$tapeinfo</code> = <i>'/etc/dcache/tape-info.xml'</i><br />
    A supplementary xml file providing information of the tape backend
    to dCache for publishing in the GLUE information system.<br />
    <b>Only</b> supported through <code>$tapeinfo_source</code> and
    <code>$tapeinfo_template</code>!
  </li>

  <li><code>$infoprovider</code> = <i>'/etc/dcache/info-provider.xml'</i><br />
    A schematic for dCache about which site-specific information will
    be published through GLUE. Service details are gathered from dCache
    automatically out-of-the-box in most aspects.<br />
    <b>Only</b> supported through <code>$infoprovider_source</code> and
    <code>$infoprovider_template</code>!
  </li>
</ul>

## Examples
Examples can be found in File_struct_def.md for configuration files.

Since this module is designed with an
[ENC](https://www.google.de/#q=puppet%20external%20node%20classifier)
in mind, there is an example for how to apply this module with Hiera-yaml files
in Hiera_Example.md.
