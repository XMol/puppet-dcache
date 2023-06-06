# Puppet Module `dcache`
Install dCache using this module.

## Requisites and dependencies

### Java

dCache is a Java program and thus requires Java to be installed. This module
though neither installs it, nor does it raise any dependency on installed
Java packages or declared Puppet resources. The simple reason for that is,
that the administrator may chose from different Java editions &ndash;
Oracle or open source, basic runtime environment or development kit. All of
these editions tend to have complicated and diverse naming conventions
for their packages. The author of this module decided, he didn't want to
open that can of worms.

### Database

Some dCache services require a RDBMS backend, traditionally a PostgreSQL
instance. Installing Postgres is _not_ part of this module. Instead,
there is a well developed public Puppet module supported by Puppetlabs
for managing PostgreSQL installations:
[puppetlabs-postgresql](https://github.com/puppetlabs/puppetlabs-postgresql).
Of course, PostgreSQL is not mandatory for dCache. In theory, any other
RDBMS should work, too.


## Service resource types

The `dcache` class will translate the layout mapping into `domain` and
`services::generic` resources, which will result in a properly populated
layout file. There are specialized resource types for a couple of
services, which allow administrators to manage related configuration files
at the same time. The documentation for them is found in
[dCache services](./dcache_services.md).

## dCache as a service

This module does _not_ define dCache as a service. The main reason is, that
a running state is not precisely defined, when the service is split over
independent processes, i.e. domains. Maybe in the future we will define
the individual domains as a service on operating system level (code
contribution is welcome).
