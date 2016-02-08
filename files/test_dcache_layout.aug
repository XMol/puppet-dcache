(* Put this file in /usr/share/augeas/lenses/tests
   It then may be used to verify the functionality of the lens
   dcache_layout.aug.
*)

module Test_dcache_layout =

let conf = "# A dCache layout file.
dcache.java.memory.heap=2g
dcache.hosts.service.broker=localhost
dcache.hosts.service.billing=localhost

[dCacheDomain]
  dcache.java.memory.heap=8g
[dCacheDomain/poolmanager]
poolmanager.cell.name=PoolManager
[dCacheDomain/topo]

[billingDomain]
[billingDomain/billing]
  billing.text.format.mover-info.message = [$cellType$:$cellName$,$type$] $if(storage)$$$$storage.storageClass$@$storage.hsm$$$$else$<Unknown>$endif$ {$rc$:\"$message$\"}
[gftp-${host.name}Domain]
[gftp-${host.name}Domain/ftp]
  ftp.authn.protocol =gsi
  ftp.net.internal= 1.2.3.4
[nfs-${host.name}Domain]
[nfs-${host.name}Domain/nfs]
  nfs.version=4.1

[${host.name}Domain]
[${host.name}Domain/pool]
  pool.name=my_pool

# Evil attempt to trick Augeas.
[service]
[service/service]
  service = service/service
"

test DCacheLayout.lns get conf =
{ "properties"
    { "#comment" = "A dCache layout file." }
    { "dcache.java.memory.heap" = "2g" }
    { "dcache.hosts.service.broker" = "localhost" }
    { "dcache.hosts.service.billing" = "localhost" }
}
{ }
{ "domain" = "dCacheDomain"
    { "properties"
        { "dcache.java.memory.heap" = "8g" }
    }
    { "service" = "dCacheDomain/poolmanager"
        { "properties"
            { "poolmanager.cell.name" = "PoolManager" }
        }
    }
    { "service" = "dCacheDomain/topo" }
}
{ }
{ "domain" = "billingDomain"
    { "service" = "billingDomain/billing"
        { "properties"
            { "billing.text.format.mover-info.message" = "[$cellType$:$cellName$,$type$] $if(storage)$$$$storage.storageClass$@$storage.hsm$$$$else$<Unknown>$endif$ {$rc$:\"$message$\"}" }
        }
    }
}
{ "domain" = "gftp-${host.name}Domain"
    { "service" = "gftp-${host.name}Domain/ftp"
        { "properties"
            { "ftp.authn.protocol" = "gsi"}
            { "ftp.net.internal" = "1.2.3.4" }
        }
    }
}
{ "domain" = "nfs-${host.name}Domain"
    { "service" = "nfs-${host.name}Domain/nfs"
        { "properties"
            { "nfs.version" = "4.1" }
        }
    }
}
{ }
{ "domain" = "${host.name}Domain"
    { "service" = "${host.name}Domain/pool"
        { "properties"
            { "pool.name" = "my_pool" }
        }
    }
}
{ }
{ "#comment" = "Evil attempt to trick Augeas." }
{ "domain" = "service"
    { "service" = "service/service"
        { "properties"
            { "service" = "service/service" }
        }
    }
}

test DCacheLayout.lns put conf after set "/properties/dcache.java.memory.heap" "6g" =
"# A dCache layout file.
dcache.java.memory.heap=6g
dcache.hosts.service.broker=localhost
dcache.hosts.service.billing=localhost

[dCacheDomain]
  dcache.java.memory.heap=8g
[dCacheDomain/poolmanager]
poolmanager.cell.name=PoolManager
[dCacheDomain/topo]

[billingDomain]
[billingDomain/billing]
  billing.text.format.mover-info.message = [$cellType$:$cellName$,$type$] $if(storage)$$$$storage.storageClass$@$storage.hsm$$$$else$<Unknown>$endif$ {$rc$:\"$message$\"}
[gftp-${host.name}Domain]
[gftp-${host.name}Domain/ftp]
  ftp.authn.protocol =gsi
  ftp.net.internal= 1.2.3.4
[nfs-${host.name}Domain]
[nfs-${host.name}Domain/nfs]
  nfs.version=4.1

[${host.name}Domain]
[${host.name}Domain/pool]
  pool.name=my_pool

# Evil attempt to trick Augeas.
[service]
[service/service]
  service = service/service
"
