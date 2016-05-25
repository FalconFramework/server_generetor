require "falcon_factory/version"
require 'yaml'
require 'active_support/inflector'

module FalconFactory

  class FalconMain
    def its_ok
      puts "ok"
    end

    def process(str)
      "#{str} agora foi"
    end

  end

  # Your code goes here...
end
