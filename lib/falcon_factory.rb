require "falcon_factory/version"
require "falcon_factory/falcon_main"

module FalconFactory

  def self.process_factory(model_path, target_path)
    falcon_main = FalconMain.new
    proccess = falcon_main.process(model_path, target_path)
    proccess
  end

  # Your code goes here...
end
