(* Put this file in /usr/share/augeas/lenses/tests
   It then may be used to verify the functionality of the lens
   poolmanager.aug.
*)

module Test_poolmanager =

let conf ="# Setup of PoolManager
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
psu create pool pool_A
psu create pool pool_B
psu create pool pool_C
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
# PartitionManager
# Allow only one more cached copy than we have stage pools per default.
pm create -type=wass default
pm set default -max-copies=3 -stage-allowed=yes
"

test PoolManager.lns get conf =
  { "#comment" = "Setup of PoolManager" }
  { "#comment" = "The units ..." }
  { "psu"
    { "create"
      { "unit" = "0.0.0.0/0.0.0.0"
        { "type" = "net" }
      }
    }
  }
  { "psu"
    { "create"
      { "unit" = "*/*"
        { "type" = "protocol"  }
      }
    }
  }
    { "psu"
    { "create"
      { "unit" = "*@*"
        { "type" = "store" }
      }
    }
  }
  { "#comment" = "The unit groups ..." }
  { "psu"
    { "create"
      { "ugroup" = "any-store" }
    }
  }
  { "psu"
    { "addto"
      { "ugroup"
        { "any-store" = "*@*" }
      }
    }
  }
  { "psu"
    { "addto"
      { "ugroup"
        { "any-store" = "*/*" }
      }
    }
  }
  { "psu"
    { "addto"
      { "ugroup"
        { "any-store" = "0.0.0.0/0.0.0.0" }
      }
    }
  }
  { "#comment" = "The pools ..." }
  { "psu"
    { "create"
      { "pool" = "pool_A" }
    }
  }
  { "psu"
    { "create"
      { "pool" = "pool_B" }
    }
  }
  { "psu"
    { "create"
      { "pool" = "pool_C" }
    }
  }
  { "#comment" = "The pool groups ..." }
  { "psu"
    { "create"
      { "pgroup" = "all-pools" }
    }
  }
  { "psu"
    { "addto"
      { "pgroup"
        { "all-pools" = "pool_A" }
      }
    }
  }
  { "psu"
    { "addto"
      { "pgroup"
        { "all-pools" = "pool_B" }
      }
    }
  }
  { "psu"
    { "addto"
      { "pgroup"
        { "all-pools" = "pool_C" }
      }
    }
  }
  { "#comment" = "The links ..." }
  { "psu"
    { "create"
      { "link" = "link-one"
        { "1" = "any-store" }
      }
    }
  }
  { "psu"
    { "set"
      { "link" = "link-one"
        { "readpref" = "10" }
        { "writepref" = "10" }
        { "cachepref" = "0" }
        { "p2ppref" = "0" }
      }
    }
  }
  { "psu"
    { "addto"
      { "link"
        { "link-one" = "all-pools" }
      }
    }
  }
  { "psu"
    { "create"
      { "link" = "link-two"
          { "1" = "any-store" }
          { "2" = "any-protocol" }
          { "3" = "any-net" }
      }
    }
  }
  { "psu"
    { "set"
      { "link" = "link-two"
        { "section" = "random" }
        { "cachepref" = "10" }
        { "p2ppref" = "10" }
      }
    }
  }
  { "psu"
    { "addto"
      { "link"
        { "link-two" = "pool_C" }
      }
    }
  }
  { "#comment" = "The link groups ..." }
  { "psu"
    { "create"
      { "linkGroup" = "TheLinkGroup" }
    }
  }
  { "psu"
    { "set"
      { "linkGroup"
        { "custodialAllowed"
          { "TheLinkGroup" = "false" }
        }
      }
    }
  }
  { "psu"
    { "set"
      { "linkGroup"
        { "replicaAllowed"
          { "TheLinkGroup" = "true" }
        }
      }
    }
  }
  { "psu"
    { "set"
      { "linkGroup"
        { "nearlineAllowed"
          { "TheLinkGroup" = "false" }
        }
      }
    }
  }
  { "psu"
    { "set"
      { "linkGroup"
        { "outputAllowed"
          { "TheLinkGroup" = "false" }
        }
      }
    }
  }
  { "psu"
    { "set"
      { "linkGroup"
        { "onlineAllowed"
          { "TheLinkGroup" = "true" }
        }
      }
    }
  }
  { "psu"
    { "addto"
      { "linkGroup"
        { "TheLinkGroup" = "link-one" }
      }
    }
  }
  { "#comment" = "Recalls" }
  { "rc"
    { "onerror" = "suspend" }
  }
  { "rc"
    { "max retries" = "100" }
  }
  { "rc"
    { "retry" = "3600" }
  }
  { "rc"
    { "poolpingtimer" = "600" }
  }
  { "rc"
    { "max restore" = "unlimited" }
  }
  { "rc"
    { "sameHostCopy" = "besteffort" }
  }
  { "rc"
    { "max threads" = "0" }
  }
  { "#comment" = "PartitionManager" }
  { "#comment" = "Allow only one more cached copy than we have stage pools per default." }
  { "pm"
    { "create" = "default"
      { "type" = "wass" }
    }
  }
  { "pm"
    { "set" = "default"
      { "max-copies" = "3" }
      { "stage-allowed" = "yes" }
    }
  }
