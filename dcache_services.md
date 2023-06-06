# Specialized dCache service resource types

Instead of managing the numerous configuration files for dCache,
this module offers a selection of resource types, that are focussed on
managing dCache's services on a higher level.

All of the following resource types accept the `properties` parameter &ndash;
a hash of key-value-pairs &ndash; that will be kept in the layout files with
their respective entities. Also, all of them *require* the `domain` parameter
to be set. Though this is done automatically when defining services
though the `$dcache::layout` parameter.

Hence, only the additionally supported parameters will be listed and
they are mandatory if there is no default value stated with them.

## `dcache::services::generic`

This resource will add a service to a specific domain in
the layout file. In fact, all following resource types internally fall back
to this one, plus additional decoration and side effects.

### Parameters

* `String[1] service = $title`  
The specific service type supported by dCache.

## `dcache::services::admin`

dCache's admin service keeps its own `authorized_keys` file, which can be
managed through this type, specifically its
`authorized_keys` parameter. Under the hood, we fall back to the Puppet
build-in `ssh_authorized_key` type. Thus all parameters are available for
utilization and the file will be managed with Augeas behind the scenes.

### Parameters

* `$authorized_keys`
  ```puppet
  Hash[
      String[1],
      Struct[{
        Optional['name'] => NotUndef[String[1]],
        'ensure'         => Optional[Enum['present', 'absent']],
        'key'            => NotUndef[String[1]],
        'options'        => Optional[Array[Pattern[/^\w+=.+$/]]],
        'provider'       => Optional['parsed'],
        'target'         => Optional[Stdlib::Absolutepath],
        'user'           => Optional[Variant[String[1], Integer[0]]],
        'type'           => Optional[Enum[
          'ssh-dss', 'ssh-rsa',
          'ecdsa-sha2-nistp256', 'ecdsa-sha2-nistp384', 'ecdsa-sha2-nistp521',
          'ssh-ed25519', 'dsa', 'ed25519', 'rsa',
        ]],
      }]
  ]
  ```

### Example

```puppet
dcache::services::admin { 'dCacheDomain/admin':
  domain          => 'dCacheDomain',
  authorized_keys => {
    'dCache admin'    => {
      type => ssh-rsa,
      key  => 'AAAA(...)H19IQ==',
    },
    'Kermit the Frog' => {
      type => ssh-rsa,
      key  => 'AAAA(...)3A/7==',
    },
  },
}
```

## `dcache::services::frontend`

The frontend is the successor to the discontinued webinterface, not to be confused with the legacy httpd, which is still present and functional.

The Puppet class dedicated to this service merely may deploy well-known resources `security.txt` and `wlcg-tape-rest-api` in addition to the regular stuff.

### Example

Here we don't actually deploy a `security.txt` file, but merely redirect clients to KIT`s general `security.txt`.

```yaml
classes:
  - dcache::services::frontend

dcache.wellknown!security-txt.uri = https://www.kit.edu/.well-known/security.txt
dcache::layout:
  frontendDomain:
    frontend:
      security_txt: Must provide something...
      wlcg_tape_api:
        sitename: "%{lookup('dcache::setup.\"info-provider.se-unique-id\"')}"
        endpoints:
          - uri: "https://%{fqdn}:3880/api/v1/tape"
            version: v1
            metadata:
              quality-level: pre-production
```

## `dcache::services::gplazma`

gPlazma potentially uses several different configuration files at once.
Some of them can be managed by the `dcache::services::gplazma` resource
individually.

### Parameters

* `String[1] $gplazma`  
The `gplazma.conf` file is quite compact already and puts heavy weight on
the order and appearance for each line, it may even contain completely
identical lines more often than once. So there is actually no point to
manage this file by template or Augeas. Therefor the content should be
provided verbatim.
* `$authzdb = {}`
  ```puppet
  Hash[
    String[1],
    Variant[
      Enum['2.1', '2.2', 2.1, 2.2],
      Struct[{
        NotUndef['login']  => String[1],
        NotUndef['access'] => Enum['read-only', 'read-write'],
        NotUndef['uid']    => Integer[0],
        NotUndef['gids']   => Array[Integer[0]],
        NotUndef['home']   => Stdlib::Absolutepath,
        NotUndef['root']   => Stdlib::Absolutepath,
        Optional['extra']  => Stdlib::Absolutepath,
      }]
    ]
  ]
  ```
  Define the dCache logins to be stored in `storage_authzdb`.
* `$gridmap = []`
  ```puppet
  Array[
    Struct[
      NotUndef['dn']    => String[1],
      NotUndef['login'] => String[1],
    ]
  ]
  ```
  List of direct mapping rules for user DNs onto dCache logins.
* `$kpwd = {}`
  ```puppet
  Struct[{
    Optional['mappings'] => Hash[String[1], String[1]],
    Optional['logins']   =>
      Hash[
        String[1],
        Struct[{
          NotUndef['access'] => Enum['read-only', 'read-write'],
          NotUndef['uid']    => Integer[0],
          NotUndef['gid']    => Integer[0],
          NotUndef['home']   => Stdlib::Absolutepath,
          NotUndef['root']   => Stdlib::Absolutepath,
          Optional['extra']  => Stdlib::Absolutepath,
          NotUndef['dns']    => Array[String[1]],
        }]
      ],
    Optional['passwds']  =>
      Hash[
        String[1],
        Struct[{
          NotUndef['pwdhash'] => String[8, 8],
          NotUndef['access']  => Enum['read-only', 'read-write'],
          NotUndef['uid']     => Integer[0],
          NotUndef['gid']     => Integer[0],
          NotUndef['home']    => Stdlib::Absolutepath,
          NotUndef['root']    => Stdlib::Absolutepath,
          Optional['extra']   => Stdlib::Absolutepath,
        }]
      ],
  }]
  ```
  Define the entire content of the `kpwd.file`.
* `$vorolemap = []`
  ```puppet
  Array[
    Struct[
      NotUndef['dn']    => String[1],
      NotUndef['fqan']  => String[1],
      NotUndef['login'] => String[1],
    ]
  ]
  ```
  Similarly to `$gridmap`, define a list of mapping rules for user DNs
  supplemented with VOMS roles onto dCache logins.

### Example

```puppet
dcache::services::gplazma { 'dCacheDomain/gplazma':
  domain    => 'dCacheDomain',
  gplazma   => @(EOF),
    auth optional x509
    auth sufficient voms
    auth optional kpwd

    map sufficient kpwd
    map optional vorolemap
    map optional authzdb

    session sufficient kpwd
    session optional authzdb
    | EOF
  kpwd      => {
    version  => '2.1',
    mappings => {
      '/C=DE/O=GermanGrid/CN=Jesus Christ' => 'jesus',
    },
    logins   => {
      jesus => {
        access => 'read-write',
        uid    => '600'
        gid    => '600'
        home   => '/'
        root   => '/'
        dns    => [
          '/C=DE/O=GermanGrid/CN=Jesus Christ',
        ],
      },
    },
    passwds   => {
      jesus => {
        pwdhash => '12345adf',
        access  => 'read-write',
        uid     => '600',
        gid     => '600',
        home    => '/',
        root    => '/',
      },
    },
  },
  vorolemap => [
    {
      dn    => '*',
      fqan  => '/christian',
      login => 'christian',
    },
    {
      dn    => '*',
      fqan  => '/christian/roman/Role=bishop',
      login => 'bishops',
    },
    {
      dn    => '/C=DE/O=GermanGrid/CN=Jesus Christ',
      # List the fqan key with the empty string for no real value.
      fqan  => '',
      login => 'jesus',
    },
  ],
  authzdb => {
    version   => "2.1",
    jesus     => {
      access => 'read-write',
      uid    => '22001',
      gids   => [ '5850', '5900', ],
      home   => '/',
      root   => '/',
    },
    christian => {
      access => 'read-only',
      uid    => '17001',
      gids   => [ '5900', ],
      home   => '/',
      root   => '/',
    },
    bishops   => {
      access => 'read-write',
      uid    => '22100',
      gids   => [ '5900', ],
      home   => '/',
      root   => '/',
    },
  },
}
```

## `dcache::services::infoprovider`

This is the exception among the service resource types, in that it
actually doesn't add any dCache service to the layout. Its sole purpose
is to source the `info-provider.xml` and `tape-info.xml` files from
somewhere. Both configuration files are supposed to be XML files, which
are best managed by sourcing them from somewhere.

### Parameters

* `Optional[Stdlib::Filesource] $infoprovider = undef`
* `Optional[Stdlib::Filesource] $tapeinfo = undef`

### Example

```puppet
dcache::services::infoprovider { 'Info definitions':
  tapeinfo     => 'file:///dcache_config/tape-info.xml',
  infoprovider => 'file:///dcache_config/info-provider.xml',
}
```

## `dcache::services::nfs`

dCache may export its virtual namespace through the nfs service. Here
we provide means to add those exports to the system's default
exports file.

### Parameters

* `Hash[Stdlib::Absolutepath, Hash[String[1], Array[String[1]]]] $exports`

### Example

```puppet
dcache::services::nfs { "The nfs service":
  domain  => 'nfsDomain',
  exports => {
    '/'     => { 'localhost' => [ 'rw', ], },
    '/pnfs' => {
      'localhost' => [ 'rw', 'no_root_squash', ],
      'headnode'  => [ 'rw', 'no_root_squash', ],
    },
  },
}
```

## `dcache::services::pool`

This is syntactic sugar to define a pool more easily.

### Parameters

* `Integer[1] $size`  
The designated size of the pool as a number (no suffixes allowed).
* `String[1] $poolname = $title`  
Utilize the resource title as pool name by default.
* `String[1] $domain = "${title}Domain"`  
Assume we have a dedicated domain for each pool service instance.

### Example

```puppet
dcache::services::pool {
  ['pool-A', 'pool-B', 'pool-C']:
    domain => 'poolDomain',
    size   => 100000000000,
}
```

## `dcache::services::poolmanager`

Certainly the most complicated configuration file for dCache is
`poolmanager.conf`. Though using this module, several aspects are toned down
for the administrator. For example, one doesn't need to worry about the
exact syntax of the mostly similar but then occasionally different commands
of the file. Also, the "tree" of PoolManager entities is build bottom-up
in the file, whereas with JSON or YAML we can do the opposite, which
can be easier to maintain.

The PoolManager service does more than managing the dCache pools only. It
also keeps track on the costs for each pool, since it has to assign incoming
requests to them, it supervises all the current tape recall requests and
administrates so-called partitions for the pools. These aspects are separate
from the creation and adaptation of units, pools, links and their groupings.

### Parameters

* `Hash[String[1], String[1]] $cm  = {}`  
Settings for the Cost Module.
* `Hash[String[1], Hash[String[1], String[1]]] $pm  = {}`  
Settings for the Partition Manager.
* `Hash[String[1], String[1]] $rc  = {}`  
Settings for the Recall Module.
* `$psu = {}`  
  ```puppet
  Struct[{
    Optional[units]   => Units,
    Optional[ugroups] => Hash[String[1], Units],
    Optional[pools]   => Array[String[1]],
    Optional[pgroups] => Hash[String[1], Pgroup],
    Optional[links]   => Hash[String[1], Link],
    Optional[lgroups] => Hash[String[1], Lgroup],
  }]
  ```  
  The entire hierarchy of Pool Selection Unit entities.

#### PSU Hierarchy

This is how the respective PSU entities have to be defined.

##### Units

```puppet
Struct[{
  Optional[store]    => Array[String[1]],
  Optional[net]      => Array[String[1]],
  Optional[protocol] => Array[String[1]],
  Optional[dcache]   => Array[String[1]],
}]
```

##### Unit Groups

```puppet
Hash[String[1], Units]
```

##### Pools

```puppet
Array[String[1]]
```

##### Pool Groups

```puppet
Array[Variant[String[1], Array[String[1]]]]
```

##### Links

```puppet
Struct[{
  Optional[ugroups] => Hash[String[1], Units],
  Optional[pgroups] => Hash[String[1], Pgroup],
  Optional[prefs]   => Struct[{
    Optional[read]  => Integer[0],
    Optional[write] => Integer[0],
    Optional[cache] => Integer[0],
    Optional[p2p]   => Integer,
  }]
}]
```

##### Link Groups

```puppet
Struct[{
  Optional[allowances] => Struct[{
    Optional[online]    => Boolean,
    Optional[nearline]  => Boolean,
    Optional[replica]   => Boolean,
    Optional[custodial] => Boolean,
    Optional[output]    => Boolean,
  }],
  Optional[links]      => Hash[String[1], InputLink],
}]
```

### Example

```puppet
# List all the settings for rc litterally - including the white spaces.
$rc = {
  'onerror' => 'fail',
  'max retries' => 3,
  'max restore' => 'unlimited',
}
# Use names of partitions as key to their individual settings.
# The default partition will always exist and provide default values
# for custom partitions, even if it is not included here.
$pm = {
  'default' => {
    'type' => 'wass',
    'stage-allowed' => 'yes',
    'p2p-fortransfer' => 'yes',
  }
}
$cm = {
  'debug' => 'off',
  'update' => 'on',
  'magic' => 'on',
}
# Contrary to what PoolManager requires, psu structures may be defined
# from top to bottom - start with the large conglomerates and only
# define what you need at the right place.
$psu = {
  'lgroups' => {
    'A-linkGroup' => {
      # The default for any allowance is false. Only true needs to be set.
      'allowances' => {
        'custodial' => true,
        'nearline'  => true,
      },
      'links'      => {
        'A-link' => {
          # Redefine preference settings for this link, when the default(=0) is
          # inappropriate.
          'prefs'   => {
            'write' => 10,
          },
          'ugroups' => {
            'A_unit_group' => {
              'store' => ['A-store-unit@osm'],
            },
          },
          'pgroups' => {
            'A_pool_group' => ['pool-A'],
          },
        },
      },
    },
  },
  # Define links not included in any link group here.
  'links' => {
    'B-link' => {
      'prefs'   => {
        'cache' => 20,
      },
      'ugroups' => {
        'B_unit_group' => {
          'store' => ['B-store-unit@osm'],
        },
      },
      'pgroups' => {
        'B_pool_group' => ['pool-B'],
      },
    },
  },

  # Define these default units in any case, because PoolManager expects them.
  'units' => {
    'net'      => ['0.0.0.0/0.0.0.0'],
    'protocol' => ['*/*'],
    'store'    => ['*@*'],
  },

  # From here on you can define more unit groups and pool groups as you like.
  'ugroups' => {
    'optional_ugroup' => {
      'store' => ['ops:OPS@osm'],
    },
  },
  # Pools and pool groups are created very similar to units. Though creating
  # pools without a group is less useful.
  'pools' => ['pool-C', 'pool-D'],
  'pgroups' => {
    unused-pools => ['pool-C', 'pool-D'],
    # all-pools => will be created automatically for your convenience
  },
}
```

Note that it is not necessary to redefine the same entity multiple times.
Puppet will figure out, which entities have been declared anywhere and
make sure `poolmanager.conf` will contain the appropriate definitions
for them. Instead, focus on the high level relationships.

## `dcache::services::spacemanager`

Manage dCache's `LinkGroupAuthorization.conf` file.

### Parameters

* `Hash[String[1], Array[String[1]]] $linkgroupauth`

### Example

```puppet
dcache::services::spacemanager { 'The SpaceManager service':
  domain        => 'srmDomain',
  linkgroupauth => {
    'christian-linkGroup' => [
      'jesus',
      '/christian/Role=*',
      '/christian/roman/Role=bishop',
    ],
  }
}
```

## `dcache::services::webdav`

WebDAV is one kind of dCache door.

The Puppet class dedicated to this service merely may deploy the well-known resource `wlcg-tape-rest-api` in addition to the regular stuff.

### Example

```yaml
classes:
  - dcache::services::webdav

dcache::layout:
  webdavDomain:
    webdav:
      wlcg_tape_api:
        sitename: "%{lookup('dcache::setup.\"info-provider.se-unique-id\"')}"
        endpoints:
          - uri: "https://atlasdcacheweb.gridka.de:3880/api/v1/tape"
            version: v1
            metadata:
              quality-level: pre-production
```
