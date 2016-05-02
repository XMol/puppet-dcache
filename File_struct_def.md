# Definition of hash structures for configuration files
The `dcache` module provides templates and Augeas definitions for almost every
configuration file known to dCache. Almost every one of those have their
individual requirements to the parameter hash structures, in order to get
evaluated correctly.

Note that whenever a configuration file can be managed by template _and_
Augeas, the hash structure remains _identical_. Still only one of them will
be active for a compilation - the template will **always** have **precedence
over** Augeas flavored parameters!

Furthermore, it is possible to alter the name and location of any of the
configuration files for dCache. In order to have some understandable reference
we will use all the default names in this document.

## `dcache.env` and `dcache.conf`
Since both files are merely a list of key-value pairs, there is little to
explain for them: Simply list all the key-value pairs.

```yaml
dcache::env_template:
  JAVA_HOME: /usr/java/latest/bin
  JAVA: "${JAVA_HOME}/java"
```

## Layout file
The layout file in itself has an hierarchical design:
1. node-level properties
1. any number of domains
  2. (domain specific) properties
  2. _list_ of services
     3. service specific properties

```yaml
dcache::layout_template:
  properties:
    dcache.java.memory.heap: 512m
  poolsDomain:
    services:
      - pool:
         pool.name: poolA
         pool.size: 10g
      - pool:
         pool.name: poolB
         pool.size: 10g
  nfs3Domain:
    properties:
      dcache.user: root
    services:
      - nfs:
         nfs.version: 3
```
* Properties need to be grouped in "properties"-keyed hash structures on
  top-level and for domains.
  + Service properties don't need that anymore.
* Names for domains act as a key for another hash.
* Properties and services of a domain have to be explicitly separated from
  each other.
* Services have to be listed as an array!
  + The order in which the services are listed might be important and has to
    be preserved.
  + A domain may contain several instances of the same service, most
    prominently pools.
  + There might be cornercases were one must use explicit formatting that
    cannot be misunderstood in YAML syntax.

## `poolmanager.conf`
Certainly the most complicated configuration file for dCache is
`poolmanager.conf`. Though using this module, several aspects are toned down
for the administrator. For example, one doesn't need to worry about the
exact syntax of the mostly similar but then occasionally different syntax
of the file. Also, the "tree" of PoolManager entities is build bottom-up
in the file, whereas with the YAML syntax we can do the opposite, which
can be easier to maintain.

The PoolManager service does more than managing the dCache pools only. It
also keeps track on the costs for each pool, since it has to assign incoming
requests to them, it supervises all the current tape recall requests and
administrates so-called partitions for the pools. These aspects are separate
from the creation and adaptation of units, pools, links and their groupings.
```yaml
dcache::poolmanager_template:
  # List all the settings for rc litterally, including the white spaces.
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
  # Pools and pool groups are created very similar to pools. Though creating
  # pools without a group is less useful.
  pgroups:
    A-pools: &pg_a
      - poolA
    B-pools: &pg_b
      - poolB
  links:
    # Once again, use the name of your link as key.
    A-link: &li_a
      # Redefine preference settings for this link, when the default (=0) is
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

## Authorized keys
Not supported through templates!  
This module falls back to the Puppet build-in
`ssh_authorized_key` type. Thus all parameters are available for utilization
and the file will be managed with Augeas behind the scenes.
```yaml
dcache::authorized_keys_augeas:
  GridKa-key file server:
    type: ssh-rsa
    key: 'AAAA(...)H19IQ=='
```

## `gplazma.conf`
Not supported by either template or Augeas!  
The `gplazma.conf` file is quite
compact already, puts heavy weight on the order of appearence for each line
and may contain completely identical lines more often than once. So there
is actually no point to manage this file by template or Augeas. Simply
source it from somewhere or write its content explicitly in YAML.
```yaml
dcache::gplazma_content: |+
 auth optional x509
 auth sufficient voms
 auth optional kpwd
 
 map sufficient kpwd
 map optional vorolemap
 map optional authzdb
 
 session sufficient kpwd
 session optional authzdb
```

## `dcache.kpwd`
dCache's kpwd file is a swiss knife for authenticating users. It combines
the same capabilities of the `grid-mapfile` and `storage_authzdb` files and
it is the only method to grant access to dCache with a login and password
(this is used e.g. by the webadmin service).

```yaml
dcache::kpwd_template:
  version: 2.1
  mappings:
    /C=DE/O=GermanGrid/CN=Jesus Christ: jesus
  logins:
    jesus:
      access: read-write
      uid: 600
      gid: 600
      home: /
      root: /
      dns:
        - /C=DE/O=GermanGrid/CN=Jesus Christ
  passwds:
    jesus:
      pwdhash: 12345adf
      access: read-write
      uid: 600
      gid: 600
      home: /
      root: /
```
* Optionally set a specific version of the kpwd model.
* _mappings_ is a hash of DN to login account mappings.
* _login_ describe the login accounts in detail - **all** properties are
  **mandatory** for each login!
  + _access_ can be _read-write_ or _read-only_.
  + Set a _uid_ and a (single) _gid_.
  + Specify the path to the _home_ and _root_ directory.
  + List all DNs for this login under _dns_.
* 'passwds' introduces accounts for login with password. Besides _pwdhash_,
  which states the password for the login as a hash-string (what encryption?),
  the same additional properties as for _logins_ are required.

## `grid-mapfile` and `grid-vorolemap`
The `grid-mapfile` and `grid-vorolemap` files are very similar to each other.
In fact, the only difference is, that with the `grid-vorolemap`, one can
additionally utilize an (optional) VOMS FQAN for a login. It is quite common
to actually don't distinct for a user's DN anymore and just look for specific
FQANs.

All three credentials are mandatory for managing the `grid-vorolemap`. Providing
a FQAN for management of `grid-mapfiles` will _not_ result in a Puppet error,
but whenever dCache wants to evaluate the product, it will fail due to wrong
file syntax!
```yaml
dcache::vorolemap_augeas:
  mappings:
    - dn: "*" # Bare * has special meaning in YAML and needs to be quoted.
      fqan: /christian
      login: christian
    - dn: "*"
      fqan: /christian/roman/Role=bishop
      login: bishops
    - dn: /C=DE/O=GermanGrid/CN=Jesus Christ
      fqan: # List the fqan key, even if no value is assigned.
      login: jesus
```

## `storage_authzdb`
The `storage_authzdb` file is needed to assign uids, gids and other credentials
to virtual logins used in `grid-mapfile` or `grid-vorolemap`.

All credentials for each login are mandatory! `version` will default to '2.1'.
```yaml
dcache::authzdb_template:
  version: "2.1"
  jesus:
    access: read-write
    uid: 22001
    gids: [ 5850, 5900 ]
    home: /
    root: /
  christian:
    access: read-only
    uid: 17001
    gids: [ 5900 ]
    home: /
    root: /
  bishops:
    access: read-write
    uid: 22100
    gids: [ 5900 ]
    home: /
    root: /
```

## `LinkGroupAuthorization.conf`
The `LinkGroupAuthorization.conf` has a very easy format, listing either
(virtual) logins (steaming from `grid-mapfile` or `grid-vorolemap`) or
full FQANs under a dCache link group's name.
```yaml
dcache::linkgroupauth_template:
  christian-linkGroup:
    - jesus
    - /christian/Role=*
    - /christian/roman/Role=bishop
```

## `tape-info.xml` and `info-provider.xml`
This module does not over support to manage either of these two files by
template or Augeas. Though one may set the content of either file in YAML,
it is strongly discouraged. It is best to source the file from some other
location.
```yaml
dcache::tapeinfo_source: file://dcache_config/tape-info.xml
dcache::infoprovider_source: file://dcache_config/info-provider.xml
```
