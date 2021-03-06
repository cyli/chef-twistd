actions :add, :remove


attribute :name, :kind_of => String, :name_attribute => true
attribute :port, :kind_of => Integer, :required => false, :default => 5353
attribute :user, :regex => /^([a-z]|[A-Z]|[0-9]|_|-)+$/, :required => false, :default => "dns"
attribute :logfile, :kind_of => String, :required => false, :default => nil
attribute :pidfile, :kind_of => String, :required => false, :default => nil

attribute :secondaries, :kind_of => Hash, :required => false, :default => nil
attribute :pyzones, :kind_of => Array, :required => false, :default => nil
attribute :bindzones, :kind_of => Array, :required => false, :default => nil


def initialize( *args )
  super
  @action = :add
end
