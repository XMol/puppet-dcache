# Build in resource types
Instead of managing the numerous configuration files for dCache,
this module offers a selection of resource types, that are focussed on
managing dCache's services on a higher level.

## Overview
All of the following resource types accept the `properties` parameter -
a hash of key-value-pairs, that will be kept in the layout files with their
respective entities.

All of the `services` resource types ''require'' the `domain` parameter
to be set.

Additional parameters will be listed and they will be required if there
is no default value stated with them.

<ul>
  <li>
    <b>dcache::domain</b><br />
    <p>
      All dCache services are hosted by domains. Consequently, there has to be
      a domain for every service that is should be offered by dCache. Puppet
      will collect all defined domains and put them automatically in the
      layout file. Optionally, any properties can be attached to the domain, too.
    </p>
  </li>
    
  <li>
    <b>dcache::services::generic</b><br />
    <i>service = $title</i>
    <p>
      This resource will add a service to a <code>dcache::domain</code> in
      the layout file. Optionally, any properties may be included. In fact,
      all following resource types internally fall back to this one, plus
      managing individual files.
    </p>
  </li>
  
  <li>
    <b>dcache::services::admin</b><br />
    <i>authorized_keys</i>
    <p>Manage the authorized_keys file for dCache's admin service.</p>
  </li>
  
  
  <li>
    <b>dcache::services::gplazma</b><br />
    <i>
      gplazma<br />
      authzdb = {}<br />
      gridmap = {}<br />
      kpwd = {}<br />
      vorolemap = {}
    </i>
    <p>
      Manage `gplazma.conf` and optionally a couple more related files.
      Refer to [file_struct_def](file_struct_def.md) for documentation on
      the respective syntax definitions.
    </p>
  </li>
  
  <li>
    <b>dcache::services::infoprovider</b><br />
    <i>
      infoprovider = ''<br />
      tapeinfo = ''
    </i>
    <p>
      This is the exception among the services resource types, in that it
      actually doesn't add any dCache service to the layout. Its sole purpose
      is to source the `info-provider.xml` and `tape-info.xml` files from
      somewhere.
    </p>
  </li>
  
  <li>
    <b>dcache::services::nfs</b><br />
    <i>exports</i>
    <p>Manage the exports file using Augeas.</p>
  </li>
  
  <li>
    <b>dcache::services::pool</b><br />
    <i>
      poolname = "$title"<br />
      size<br />
      domain = "${title}Domain"
    </i>
    <p>
      This is syntactic sugar to define a pool more easily.
    </p>
  </li>
    
  <li>
    <b>dcache::services::poolmanager</b><br />
    <i>poolmanager</i>
    <p>
      Manage dCache's `poolmanager.conf` file; detailed documentation on
      how to do that can be found in [file_struct_def](file_struct_def.md).
    </p>
  </li>
    
  <li>
    <b>dcache::services::spacemanager</b><br />
    <i>linkgroupauth</i>
    <p>
      Manage dCache's `LinkGroupAuthorization.conf` file; detailed
      documentation on how to do that can be found in
      [file_struct_def](file_struct_def.md).
    </p>
  </li>
</li>

## Usage

First create domains...

```puppet
dcache::domain { 'dCacheDomain':
  properties => {
    'dcache.java.memory.heap' => '2g',
  }
}
```

Then add services to them...

```puppet
dcache::services::poolmanager { 'Unimportant but unique title':
  domain      => 'dCacheDomain',
  poolmanager => $large_complicated_hash,
}
```

If there need to be more of the same service in one domain, e.g. pools,
the resource's title  and service become important.

```puppet
$the_pool = 'pool1'
dcache::services::generic { $the_pool:
  domain     => 'poolDomain',
  service    => 'pool',
  properties => {
    'pool.name' => $the_pool,
  }
}
```
