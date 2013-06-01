actions :add, :remove

attribute :name, :kind_of => String, :name_attribute => true
attribute :twistd_command, :kind_of => String, :required => true

# arguments to provide to the twistd command, line by line
attribute :args, :kind_of => Array, :required => false, :default => []

# which ports may need to be authbinded
attribute :authbind_ports, :kind_of => Array, :required => false, :default => []

# where the logfile should go - default no logs
attribute :logfile, :kind_of => String, :required => false, :default => nil

# where the pidfile should go - default /tmp/<service_name>.twistd.pid
attribute :pidfile, :kind_of => String, :required => false, :default => nil

# the user to run the service as (generally should not run as root)
attribute :user, :regex => /^([a-z]|[A-Z]|[0-9]|_|-)+$/, :required => false, :default => "root"


def initialize( *args )
  super
  @action = :add
end
