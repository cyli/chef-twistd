require 'minitest/autorun'

# chef uses erubus and not erb for tmeplates:
# http://docs.opscode.com/essentials_cookbook_templates.html
require 'erubis'
require 'ostruct'

# also, check out http://www.kuwata-lab.com/erubis/users-guide.html,
# specifically http://www.kuwata-lab.com/erubis/users-guide.06.html for docs

template_file = File.expand_path(File.join(
  File.dirname(__FILE__), "../templates/default/twistd_plugin.conf.erb"))

TEMPLATE =  Erubis::Eruby.new(File.read(template_file))


class TestTemplate < Minitest::Test
  # If the user is root, no need for "su -"
  def test_user_is_root
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => []
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "Twistd service: service"
      author                          "Ying Li <cyli@twistedmatrix.com>"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec twistd -n \\
          --pidfile /tmp/pidfile \\
          command
    eof
    assert_equal expected, result
  end

  # If the user is not root, run su -
  def test_user_not_root
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'me',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => []
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "Twistd service: service"
      author                          "Ying Li <cyli@twistedmatrix.com>"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec su - me -c 'twistd -n \\
          --pidfile /tmp/pidfile \\
          command'
    eof
    assert_equal expected, result
  end

  # If the authbind ports are provided but the user is root, not authbinded
  def test_authbind_user_root
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => [],
      :authbinded => true
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "Twistd service: service"
      author                          "Ying Li <cyli@twistedmatrix.com>"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec twistd -n \\
          --pidfile /tmp/pidfile \\
          command
    eof
    assert_equal expected, result
  end

  # If the authbind ports are provided and the user is not root, authbinded
  def test_authbind_user_not_root
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'me',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => [],
      :authbinded => true
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "Twistd service: service"
      author                          "Ying Li <cyli@twistedmatrix.com>"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec su - me -c 'authbind --deep twistd -n \\
          --pidfile /tmp/pidfile \\
          command'
    eof
    assert_equal expected, result
  end

  # If the logfile is provided, include it as an option
  def test_include_logfile
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => [],
      :logfile => '/var/log/log'
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "Twistd service: service"
      author                          "Ying Li <cyli@twistedmatrix.com>"

      start on runlevel [2345]
      stop on runlevel [016]

      respawn

      exec twistd -n \\
          --pidfile /tmp/pidfile \\
          --logfile /var/log/log \\
          command
    eof
    assert_equal expected, result
  end

  # If args are included, each is printed on a separate line
  def test_line_per_arg
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => ['arg1', 'arg2', 'arg3']
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "Twistd service: service"
      author                          "Ying Li <cyli@twistedmatrix.com>"

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
    assert_equal expected, result
  end

  # If args are included, each is printed on a separate line.  The closing
  # single quote is in the right place, if the user is not root
  def test_line_per_arg_as_non_root
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'me',
      :twistd_command => 'command',
      :pidfile => '/tmp/pidfile',
      :args => ['arg1', 'arg2', 'arg3']
    )

    expected = <<-eof.gsub(/^ {6}/, '')
      description                     "Twistd service: service"
      author                          "Ying Li <cyli@twistedmatrix.com>"

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
    assert_equal expected, result
  end

end
