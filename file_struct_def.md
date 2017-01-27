# Definition of hash structures for configuration files
This module offers templates to manage most of the configuration files
used for administrating dCache. In most situations we chose to not look
for specific properties, but write key-value-pairs literally into the
configuration files. This approach is necessary, because dCache allows
administrators to set any properties in the dcache.conf and layout files,
even if they are not known to dCache. Those properties may be evaluated for
example by plugins.

Note that, it is possible to alter the name
and location of any of the configuration files for dCache. In order to have
some understandable reference, we will use all the default names in this
document.

## `dcache.env` and `dcache.conf`
Since both files are merely a list of key-value pairs, there is little to
explain for them: Simply list all the key-value pairs.

```puppet
dcache {
  env => {
    JAVA_HOME => '/usr/java/latest/bin',
    JAVA      => '${JAVA_HOME}/java'
  },
}
```

## Layout file
The layout files are pieced together from all defined domain and service
resources automatically. Each of those in turn may have their respective set
of key-value-properties. Settings that are supposed to be written at the top
of the layout files may be set with the `dcache::layout_globals` parameter.

## `poolmanager.conf`
Certainly the most complicated configuration file for dCache is
`poolmanager.conf`. Though using this module, several aspects are toned down
for the administrator. For example, one doesn't need to worry about the
exact syntax of the mostly similar but then occasionally different commands
of the file. Also, the "tree" of PoolManager entities is build bottom-up
in the file, whereas with YAML we can do the opposite, which
can be easier to maintain.

The PoolManager service does more than managing the dCache pools only. It
also keeps track on the costs for each pool, since it has to assign incoming
requests to them, it supervises all the current tape recall requests and
administrates so-called partitions for the pools. These aspects are separate
from the creation and adaptation of units, pools, links and their groupings.
```yaml
dcache::poolmanager_template:
  # List all the settings for rc litterally - including the white spaces.
  rc:
    onerror: fail
    max retries: 3
    max restore: unlimited
  # Use names of partitions as key to their individual settings.
  # The default partition will always exist and provide default values
  # for custom partitions, even if it is not included here.
  pm:
    default:
      type: wass
      # If they're not quoted, values like "yes", "no", "on" or "off" will
      # be interpreted in YAML and converted to boolean values!
      stage-allowed: "yes"
      p2p-fortransfer: "yes"
  cm:
    debug: "off"
    update: "on"
    magic: "on"
  # List your desired units for each kind. Use quotes to avoid issues with
  # some characters.
  # These most generic, basic units always have to be created explicitly, if
  # you are relying on them.
  units:
    net:
      - 0.0.0.0/0.0.0.0
    protocol:
      - '*/*'
    store:
      - '*@*'
  ugroups:
    # Use the name of your unit group as key to its contained units.
    # This unit group will be referenced later, so we place an anchor here.
    the_ugroup: &ug
      # Like with the 'units' structure before, state the units contained
      # in each group according to their kind.
      # New entities don't have to be created in advance. Simply assign them
      # exactly in the place they have to be. The `dcache` module will take
      # care that they are present in `poolmanager.conf` as required.
      store:
        - 'ops:OPS@osm'
  # Pools and pool groups are created very similar to units. Though creating
  # pools without a group is less useful.
  pgroups:
    A-pools: &pg_a
      - poolA
    B-pools: &pg_b
      - poolB
  links:
    # Once again, use the name of your link as key.
    A-link: &li_a
      # Redefine preference settings for this link, when the default(=0) is
      # inappropriate.
      prefs:
        cache: 20
      ugroups:
        # Define new unit groups here like before, or insert aliases.
        # The name of the unit group does not need to match earlier anchors,
        # as long as it remains unique. The contained units can be aliassed.
        a_unit_group: *ug
      pgroups:
        a_pool_group: *pg_a
    B-link: &li_b
      prefs:
        read: 40
        p2p: -1
      ugroups:
        a_unit_group: *ug
      pgroups:
        b_pool_group: *pg_b
  lgroups:
    # Use references when you want to avoid duplication of information.
    # However, it is perfectly possible to define the entire tree without them
    # or any combination in between.
    C-linkGroup:
      # The default for any allowance is 'false'. Only 'true' needs to be set.
      allowances:
        custodial: true
        nearline: true
      links:
        C-link:
          prefs:
            write: 10
          ugroups:
            a_unit_group: *ug
          pgroups:
            c_pool_group:
              - poolC
    D-linkGroup:
      allowances:
        replica: true
        online: true
      links:
        shared-disk-only-link:
          prefs:
            read: 10
            write: 10
          ugroups:
            shared-disk-only-store:
              store:
                - 'ops:OPS-disk-only@osm'
          pgroups:
            D-pools:
              - poolD
```

## Admin's Authorized keys
dCache's admin service keeps its own authorized_keys file, which can be
managed through the `dcache::services::admin` type, specifically its
`authorized_keys` parameter. Under the hood, we fall back to the Puppet
build-in `ssh_authorized_key` type. Thus all parameters are available for
utilization and the file will be managed with Augeas behind the scenes.

```puppet
dcache::services::admin { 'The admin service':
  domain          => 'dCacheDomain',
  authorized_keys => {
    'dCache admin' => {
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

## gPlazma configuration
gPlazma potentially uses several different configuration files at once.
Most of them can be managed by the `dcache::services::gplazma` resource
individually.

### `gplazma.conf`
The `gplazma.conf` file is quite compact already and puts heavy weight on
the order and appearence for each line, it may even contain completely
identical lines more often than once. So there is actually no point to
manage this file by template or Augeas. Therefor it expects the content
verbatim as `gplazma` parameter.

```puppet
$gplazma_content = 'auth optional x509
auth sufficient voms
auth optional kpwd
 
map sufficient kpwd
map optional vorolemap
map optional authzdb
 
session sufficient kpwd
session optional authzdb'
```

### `dcache.kpwd`
dCache's kpwd file is a swiss knife for authenticating users. It combines
the same capabilities of the 'grid-mapfile' and 'storage_authzdb' files and
it is the only method to grant access to dCache with a login and password
(this is used e.g. by the webadmin service).


* Optionally set a specific version of the kpwd model.
* _mappings_ is a hash of DN to login account mappings.
* _logins_ describe the login accounts in detail - **all** properties are
  **mandatory** for each login!
  + _access_ can be _read-write_ or _read-only_.
  + Set a _uid_ and a (single) _gid_.
  + Specify the path to the _home_ and _root_ directory.
  + List all DNs for this login under _dns_.
* _passwds_ introduces accounts for password-authenticated logins. Besides
  _pwdhash_, which states the password for the login as a hash-string, the
  same additional properties as for _logins_ are required.

```puppet
$kpwd = {
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
}
```

Note that entries for _mappings_ and _logins_ should cross-reference each other.
Ie. every _mappings_ value must be represented with a key in _logins_ and the
respective _mappings_ key must appear among the _logins_' dns list.

## `grid-mapfile` and `grid-vorolemap`
The 'grid-mapfile' and 'grid-vorolemap' files are very similar to each other.
In fact, the only difference is, that with the 'grid-vorolemap', one can
additionally utilize an (optional) VOMS FQAN for a login. It is quite common
to actually don't distinct for a user's DN anymore and just look for specific
FQANs.

All three credentials are mandatory for managing the 'grid-vorolemap'. Providing
a FQAN for management of 'grid-mapfiles' will _not_ result in a Puppet error,
but whenever dCache wants to evaluate the product, it will fail due to wrong
file syntax!

```puppet
$vorolemap = {
  mappings => [
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
      fqan  => "",
      login => 'jesus',
    },
  ],
}
```

## `storage_authzdb`
The 'storage_authzdb' file is needed to assign uids, gids and other credentials
to virtual logins used in 'grid-mapfile' or 'grid-vorolemap'.

All credentials for each login are mandatory! `version` will default to '2.1'.

```puppet
$authzdb = {
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
}
```

### Put them all together
Finally, we can put all those together with the resource type.

```puppet
dcache::services::gplazma { 'The gPlazma service':
  domain    => 'gplazmaDomain',
  gplazma   => $gplazma_content,
  kpwd      => $kpwd,
  vorolemap => $vorolemap,
  authzdb   => $authzdb,
} 
```

## `LinkGroupAuthorization.conf`
'LinkGroupAuthorization.conf' is used by dCache's SpaceManager service and
has a very easy format, listing either (virtual) logins (steaming from
'grid-mapfile' or 'grid-vorolemap') or full FQANs under a dCache link
group's name.

```puppet
$linkgroupauth = {
  christian-linkGroup => [
    'jesus',
    '/christian/Role=*',
    '/christian/roman/Role=bishop',
  ],
}
dcache::services::spacemanager { "The SpaceManager service':
  domain        => 'srmDomain',
  linkgroupauth => $linkgroupauth,
}
```

## `tape-info.xml` and `info-provider.xml`
This module does not offer support to manage either of these two files
beyond sourcing them from some other location.

```puppet
dcache::services::infoprovider { "Info definitions":
  tapeinfo     => 'file://dcache_config/tape-info.xml',
  infoprovider => 'file://dcache_config/info-provider.xml',
}
```

## `/etc/exports`
This is the standard file for configuring any (NFS) exports for a host and
dCache uses it for publishing its own namespace via NFS, too. The format
of the structure is straight forward:
* Use the directory to be exported as top level key.
* Align any client specification with the exported directory as another key.
* List all client options to the export as an array.

```puppet
dcache::services::nfs { "The nfs service":
  domain  => 'nfsDomain',
  exports => {
    '/'     => { localhost => [ 'rw', ], },
    '/pnfs' => {
      localhost => [ 'rw', 'no_root_squash', ],
      headnode  => [ 'rw', 'no_root_squash', ],
    },
  },
}
```
