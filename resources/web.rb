actions :add, :remove


attribute :name, :kind_of => String, :name_attribute => true
attribute :port, :kind_of => Integer, :required => true, :default => 80
attribute :user, :regex => /^([a-z]|[A-Z]|[0-9]|_|-)+$/, :required => true, :default => "web"

attribute :logfile, :kind_of => String, :required => false, :default => nil
attribute :pidfile, :kind_of => String, :required => false, :default => nil

attribute :https_port, :kind_of => Integer, :required => false, :default => nil

attribute :path, :kind_of => String, :required => false, :default => nil
attribute :wsgi, :kind_of => String, :required => false, :default => nil
attribute :index, :kind_of => String, :required => false, :default => nil
attribute :resource_script, :kind_of => String, :required => false, :default => nil


def initialize( *args )
  super
  @action = :add
end
