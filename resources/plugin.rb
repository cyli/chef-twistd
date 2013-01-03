actions :add, :remove

attribute :name, :kind_of => String, :name_attribute => true
attribute :twistd_command, :kind_of => String, :required => true

# arguments to provide to the twistd command, line by line
attribute :args, :kind_of => Array, :required => true

# which ports may need to be authbinded
attribute :authbind_ports, :kind_of => Array, :required => false, :default => nil

# the directory the pid and the log files will be written to
attribute :log_dir, :kind_of => String, :required => false, :default => nil

# the user to run the service as (generally should not run as root)
attribute :user, :regex => /^([a-z]|[A-Z]|[0-9]|_|-)+$/, :required => false, :default => nil


def initialize( *args )
  super
  @action = :add
end
