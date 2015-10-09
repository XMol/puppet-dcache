(* Put this file in /usr/share/augeas/lenses/tests

   It then may be used to verify the functionality of the lens StorageAuthzdb.
*)

module Test_storageauthzdb =

let conf ="# storage-authzdb for dCache
version 2.1

authorize adm read-write 1000 100 / / /
authorize john read-write 1001 100 / /data/experiments
authorize carl read-only 1002 100,101,200 / /
"


test StorageAuthzdb.lns get conf =
  { "#comment" = "storage-authzdb for dCache" }
  { "version" = "2.1" }
  {}
  { "adm" = "read-write"
    { "uid"  = "1000" }
    { "gid"
      { "1"  = "100" }
    }
    { "home" = "/" }
    { "root" = "/" }
    { "extra" = "/" }
  }
  { "john" = "read-write"
    { "uid"  = "1001" }
    { "gid"
      { "1"  = "100" }
    }
    { "home" = "/" }
    { "root" = "/data/experiments" }
  }
  { "carl" = "read-only"
    { "uid"  = "1002" }
    { "gid"
      { "1"  = "100" }
      { "2"  = "101" }
      { "3"  = "200" }
    }
    { "home" = "/" }
    { "root" = "/" }
  }
  