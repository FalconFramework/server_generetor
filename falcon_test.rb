require_relative "falcon"
require "test/unit"

class TestFalcon < Test::Unit::TestCase

  def test_file_creation
    file = FalconScriptManager.new('test.text')
    file_exist = File.exist?('test.text')
    assert(file_exist,'File was not created.')
  end
end
