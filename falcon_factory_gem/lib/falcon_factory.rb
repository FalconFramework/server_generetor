require "falcon_factory/version"
require "falcon_factory/falcon_main"

module FalconFactory

 class Factory
  def self.process_factory(model_path, target_path)
    falcon_main = FalconMain.new
    falcon_main.create_app_factory_script(model_path, target_path)
  end
end
  # Your code goes here...
end
