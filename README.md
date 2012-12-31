An incomplete attempt at a Chef LWRP to set up (Twisted) twistd services.
(Tested only on my home infrastructure)

# Cookbook Dependencies

* [authbind](https://github.com/realityforge/chef-authbind/)

# General twistd plugin

## `twistd_plugin`

This is a general twisted plugin resource whose provider is used to implement
all the other `twistd` providers (all the other `twistd` resources are wrappers
around this resource).  It can be used to implement service for a custom
`twistd` plugin, or for the case where the other wrapper resources in this
cookbook are insufficient.

### actions

* `:add` - adds the twistd service, creating an upstart file and possibly the
    user it should be run as.  Also authbinds any necessary ports and creates
    a log directory if necessary
* `:remove` - stops the twistd service and deletes the upstart file - attempts
    to undo any authbinds and delete the user as well

### attributes

* `twistd_command` (required, *String*) - the twistd command/plugin (e.g.
    web, names, conch, etc.)
* `args` (required, *Array of Strings*) - arguments to pass to that
    particular twistd plugin.  The strings are just the command line arguments
    to pass - in the upstart script, each string will be on its own line
* `authbind_ports` (*Array of ints*) - ports that need authbinding - this isn't
    necessary if the port is greater than or equal to 1024, or if the service
    will be run as root
* `log_dir` (*String*) - the directory the Twisted logs and pidfile will be
    written to.  If not provided, by default there will be no log files and
    the pidfile will go into the home directory of the user the service will be
    run as, or `/tmp/<service_name>.twistd.pid` if the user is root or the user
    has no home directory.
* `user` (*String*) - the user the service will run as.  If the user does not
    exist, it will be created.
* `user_home` (*String*) - the home directory for the user that will run the
    service.  This can be used as a data directory, or the logs could be stored
    here as well.
* `groups` (*Array of Strings*) - any extra groups the user should belong to.
    For example, if running a Twisted web server, the user may need to also
    belong to the group `ssl_cert`

# Default `twistd` plugin resources and providers

These are resources and providers for the default plugins that come with
Twisted (only `web` and `dns` so far).  They all use the general twisted plugin resource, and all have the same actions as `twistd_plugin` - that is, `:add` and `:remove`.

### `twistd_web` attributes

* `port` (required, *int*) - the port the web server should be running on
* `https` (*int*) - the port the https version should be running on
* `path` or `index` or `wsgi` or `resource_script` (one is required, *String*)
    - only one of these should be passed - they are all different ways to
    specify the root Twisted resource (not chef resource) to use for the web
    server - see `twistd web --help` for more information
* `log_dir` (*String*) - the directory the Twisted logs and pidfile will be
    written to.  If not provided, by default there will be no log files and
    the pidfile will go into the home directory of the user the service will be
    run as, or `/tmp/<service_name>.twistd.pid` if the user is root or the user
    has no home directory.
* `user` (*String*) - the user the service will run as.  If the user does not
    exist, it will be created.  Defaults to "web".
* `user_home` (*String*) - the home directory for the user that will run the
    service.  This can be used as a data directory, or the logs could be stored
    here as well.
* `groups` (*Array of Strings*) - any extra groups the user should belong to.
    For example, since this is a web server, the user may need to also
    belong to the group `ssl_cert`

### `twistd_dns` attributes

* `port` (*int*) - the port the web server should be running on
    (defaults to 53)
* `secondaries` (*Hash of String to String*) - a hash of domains mapped to IP's
* `pyzones` (*Array of String*) - an array of paths to pyzone definitions
* `bindzones` (*Array of String*) - an array of paths to bindzone definitions
* `log_dir` (*String*) - the directory the Twisted logs and pidfile will be
    written to.  If not provided, by default there will be no log files and
    the pidfile will go into the home directory of the user the service will be
    run as, or `/tmp/<service_name>.twistd.pid` if the user is root or the user
    has no home directory.
* `user` (*String*) - the user the service will run as.  If the user does not
    exist, it will be created.  Defaults to "dns".
* `user_home` (*String*) - the home directory for the user that will run the
    service.  This can be used as a data directory, or the logs could be stored
    here as well.
