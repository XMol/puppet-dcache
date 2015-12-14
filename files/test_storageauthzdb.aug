(* Put this file in /usr/share/augeas/lenses/tests

   It then may be used to verify the functionality of the lens StorageAuthzdb.
*)

module Test_storageauthzdb =

let conf =
"# storage-authzdb for dCache
version 2.1

authorize adm read-write 1000 100 / / /
authorize john read-write 1001 100 / /data/experiments
authorize carl read-only 1002 100,101,200 / /
"


test StorageAuthzdb.lns get conf =
  { "#comment" = "storage-authzdb for dCache" }
  { "version" = "2.1" }
  {}
  { "adm" 
    { "access" = "read-write" }
    { "uid"  = "1000" }
    { "gid" = "100" }
    { "home" = "/" }
    { "root" = "/" }
    { "extra" = "/" }
  }
  { "john" 
    { "access" = "read-write" }
    { "uid"  = "1001" }
    { "gid" = "100" }
    { "home" = "/" }
    { "root" = "/data/experiments" }
  }
  { "carl" 
    { "access" = "read-only" }
    { "uid"  = "1002" }
    { "gid" = "100" }
    { "gid" = "101" }
    { "gid" = "200" }
    { "home" = "/" }
    { "root" = "/" }
  }

test StorageAuthzdb.lns put conf after
    insa "gid" "/adm/gid";
    set "/adm/gid[2]" "666" =
"# storage-authzdb for dCache
version 2.1

authorize adm read-write 1000 100,666 / / /
authorize john read-write 1001 100 / /data/experiments
authorize carl read-only 1002 100,101,200 / /
"