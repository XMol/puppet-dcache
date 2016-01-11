(* Put this file in /usr/share/augeas/lenses/tests
   It then may be used to verify the functionality of the lens
   poolmanagerflat.aug.
*)

module Test_poolmanager =

let conf = "
# Setup of PoolManager
# The units ...
psu create unit -net 0.0.0.0/0.0.0.0
psu create unit -protocol */*
psu create unit -store *@*
# The unit groups ...
psu create ugroup any-store
psu addto ugroup any-store *@*
psu addto ugroup any-store */*
psu addto ugroup any-store 0.0.0.0/0.0.0.0
# The pools ...
psu create pool pool_A -noping
psu create pool pool_B
psu create pool pool_C -disabled
# The pool groups ...
psu create pgroup all-pools
psu addto pgroup all-pools pool_A
psu addto pgroup all-pools pool_B
psu addto pgroup all-pools pool_C
# The links ...
psu create link link-one any-store
psu set link link-one -readpref=10 -writepref=10 -cachepref=0 -p2ppref=-1
psu add link link-one all-pools
psu create link link-two any-store any-protocol any-net
psu set link link-two -section=random -cachepref=10 -p2ppref=10
psu add link link-two pool_C
# The link groups ...
psu create linkGroup TheLinkGroup
psu set linkGroup custodialAllowed TheLinkGroup false
psu set linkGroup replicaAllowed TheLinkGroup true
psu set linkGroup nearlineAllowed TheLinkGroup false
psu set linkGroup outputAllowed TheLinkGroup false
psu set linkGroup onlineAllowed TheLinkGroup true
psu addto linkGroup TheLinkGroup link-one
# Recalls
rc onerror suspend
rc set max retries 100
rc set retry 3600
rc set poolpingtimer 600
rc set max restore unlimited
rc set sameHostCopy besteffort
rc set max threads 0
# Cost Module
cm set active on
cm set debug off
cm set magic on
cm set update on
# PartitionManager
# Allow only one more cached copy than we have stage pools per default.
pm create -type=wass default
pm set -max-copies=3 -stage-allowed=yes
# Set some pools read-only.
psu set pool pool_* rdonly
"

test PoolManagerFlat.lns get conf = { }
{ "#comment" = "Setup of PoolManager" }
{ "#comment" = "The units ..." }
{ "psu_create_unit" = "0.0.0.0/0.0.0.0"
  { "type" = "net" }
}
{ "psu_create_unit" = "*/*"
  { "type" = "protocol"  }
}
{ "psu_create_unit" = "*@*"
  { "type" = "store" }
}
{ "#comment" = "The unit groups ..." }
{ "psu_create_ugroup" = "any-store" }
{ "psu_addto_ugroup" = "any-store"
  { "1" = "*@*" }
}
{ "psu_addto_ugroup" = "any-store"
  { "1" = "*/*" }
}
{ "psu_addto_ugroup" = "any-store"
  { "1" = "0.0.0.0/0.0.0.0" }
}
{ "#comment" = "The pools ..." }
{ "psu_create_pool" = "pool_A"
  { "ping" = "noping" }
}
{ "psu_create_pool" = "pool_B" }
{ "psu_create_pool" = "pool_C"
  { "enabled" = "disabled" }
}
{ "#comment" = "The pool groups ..." }
{ "psu_create_pgroup" = "all-pools" }
{ "psu_addto_pgroup" = "all-pools"
  { "1" = "pool_A" }
}
{ "psu_addto_pgroup" = "all-pools"
  { "1" = "pool_B" }
}
{ "psu_addto_pgroup" = "all-pools"
  { "1" = "pool_C" }
}
{ "#comment" = "The links ..." }
{ "psu_create_link" = "link-one"
  { "ugroup" = "any-store" }
}
{ "psu_set_link" = "link-one"
  { "readpref" = "10" }
  { "writepref" = "10" }
  { "cachepref" = "0" }
  { "p2ppref" = "-1" }
}
{ "psu_addto_link" = "link-one"
  { "1" = "all-pools" }
}
{ "psu_create_link" = "link-two"
  { "ugroup" = "any-store" }
  { "ugroup" = "any-protocol" }
  { "ugroup" = "any-net" }
}
{ "psu_set_link" = "link-two"
  { "section" = "random" }
  { "cachepref" = "10" }
  { "p2ppref" = "10" }
}
{ "psu_addto_link" = "link-two"
  { "1" = "pool_C" }
}
{ "#comment" = "The link groups ..." }
{ "psu_create_linkGroup" = "TheLinkGroup" }
{ "psu_set_linkGroup_custodial" = "TheLinkGroup"
  { "1" = "false" }
}
{ "psu_set_linkGroup_replica" = "TheLinkGroup"
  { "1" = "true" }
}
{ "psu_set_linkGroup_nearline" = "TheLinkGroup"
  { "1" = "false" }
}
{ "psu_set_linkGroup_output" = "TheLinkGroup"
  { "1" = "false" }
}
{ "psu_set_linkGroup_online" = "TheLinkGroup"
  { "1" = "true" }
}
{ "psu_addto_linkGroup" = "TheLinkGroup"
  { "1" = "link-one" }
}
{ "#comment" = "Recalls" }
{ "rc_set_onerror" = "suspend" }
{ "rc_set_max_retries" = "100" }
{ "rc_set_retry" = "3600" }
{ "rc_set_poolpingtimer" = "600" }
{ "rc_set_max_restore" = "unlimited" }
{ "rc_set_sameHostCopy" = "besteffort" }
{ "rc_set_max_threads" = "0" }
{ "#comment" = "Cost Module" }
{ "cm_active" = "on" }
{ "cm_debug" = "off" }
{ "cm_magic" = "on" }
{ "cm_update" = "on" }
{ "#comment" = "PartitionManager" }
{ "#comment" = "Allow only one more cached copy than we have stage pools per default." }
{ "pm_create" = "default"
  { "type" = "wass" }
}
{ "pm_set"
  { "max-copies" = "3" }
  { "stage-allowed" = "yes" }
}
{ "#comment" = "Set some pools read-only." }
{ "psu_set_pool" = "pool_*"
  { "1" = "rdonly" }
}
