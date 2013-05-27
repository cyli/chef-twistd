require 'minitest/autorun'

require 'erb'
require 'ostruct'

template_file = File.expand_path(File.join(
  File.dirname(__FILE__), "../templates/default/twistd_plugin.conf.erb"))

TEMPLATE = ERB.new(File.new(template_file).read)


class TestTemplate < Minitest::Test
  def setup
    delete_vars = ["@service_name", "@twistd_command", "@args"]
    instance_variables.each do |ivar|
      if delete_vars.include? ivar
        remove_instance_variable(ivar)
      end
    end
  end

  # If the user is root, no need for "su -"
  def test_required_plugin_arguments
      @service_name = 'service'
      @user = 'root'
      @twistd_command = 'command'
      @args = []

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

    assert_equal expected, TEMPLATE.result(binding)
  end
end
