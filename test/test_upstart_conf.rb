require 'minitest/autorun'

# chef uses erubus and not erb for tmeplates:
# http://docs.opscode.com/essentials_cookbook_templates.html
require 'erubis'
require 'ostruct'

template_file = File.expand_path(File.join(
  File.dirname(__FILE__), "../templates/default/twistd_plugin.conf.erb"))

TEMPLATE =  Erubis::Eruby.new(File.read(template_file))


class TestTemplate < Minitest::Test
  # If the user is root, no need for "su -"
  def test_required_plugin_arguments
    result = TEMPLATE.evaluate(
      :service_name => 'service',
      :user => 'root',
      :twistd_command => 'command',
      :args => []
    )

    expected = [
      'description                     "Twistd service: service"',
      'author                          "Ying Li <cyli@twistedmatrix.com>"',
      '',
      'start on runlevel [2345]',
      'stop on runlevel [016]',
      '',
      'respawn',
      '',
      'exec twistd -n \\',
      '    command',
    ].join('\n')

    assert_equal expected, result
  end
end
