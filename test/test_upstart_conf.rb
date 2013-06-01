require 'rspec'

# chef uses erubus and not erb for tmeplates:
# http://docs.opscode.com/essentials_cookbook_templates.html
require 'erubis'
require 'ostruct'

# also, check out http://www.kuwata-lab.com/erubis/users-guide.html,
# specifically http://www.kuwata-lab.com/erubis/users-guide.06.html for docs

template_file = File.expand_path(File.join(
  File.dirname(__FILE__), "../templates/default/twistd_plugin.conf.erb"))

TEMPLATE =  Erubis::Eruby.new(File.read(template_file))


describe 'twistd_plugin upstart conf' do
  it "should not add 'su -' if the user is not root" do
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => []
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "TwistD service: service"
      author                          "chef-twistd cookbook"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec twistd -n \\
          --pidfile /tmp/pidfile \\
          command
    eof
    result.should eql expected
  end

  it "should not include 'su -' if the user is not root" do
    # the closing quote should be in the right place too
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'me',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => []
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "TwistD service: service"
      author                          "chef-twistd cookbook"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec su - me -c 'twistd -n \\
          --pidfile /tmp/pidfile \\
          command'
    eof
    result.should eql expected
  end

  it "should not authbind if authbind ports are provided but user is root" do
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => [],
      :authbinded => true
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "TwistD service: service"
      author                          "chef-twistd cookbook"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec twistd -n \\
          --pidfile /tmp/pidfile \\
          command
    eof
    result.should eql expected
  end

  it "should authbind if authbind ports are provided and user is not root" do
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'me',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => [],
      :authbinded => true
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "TwistD service: service"
      author                          "chef-twistd cookbook"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec su - me -c 'authbind --deep twistd -n \\
          --pidfile /tmp/pidfile \\
          command'
    eof
    result.should eql expected
  end

  it "should include logfile as an option if provided" do
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => [],
      :logfile => '/var/log/log'
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "TwistD service: service"
      author                          "chef-twistd cookbook"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec twistd -n \\
          --pidfile /tmp/pidfile \\
          --logfile /var/log/log \\
          command
    eof
    result.should eql expected
  end

  it "should print one arg per line, if args are provided" do
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => ['arg1', 'arg2', 'arg3']
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "TwistD service: service"
      author                          "chef-twistd cookbook"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec twistd -n \\
          --pidfile /tmp/pidfile \\
          command \\
          arg1 \\
          arg2 \\
          arg3
    eof
    result.should eql expected
  end

  it "should print one arg per line and put the quote after args" do
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'me',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => ['arg1', 'arg2', 'arg3']
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "TwistD service: service"
      author                          "chef-twistd cookbook"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec su - me -c 'twistd -n \\
          --pidfile /tmp/pidfile \\
          command \\
          arg1 \\
          arg2 \\
          arg3'
    eof
    result.should eql expected
  end

end
