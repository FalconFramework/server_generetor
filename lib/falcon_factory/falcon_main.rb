require_relative 'falcon_parse.rb'


class FalconMain
  def create_app_factory_script(model_path, target_path)
    falcon = FalconParse.new('falcon_schema.yml')
    falcon.create_api
    falcon.create_models
    falcon.create_relationships
    falcon.migrate_db
    falcon.create_query_support
  end

  # def process(model_path, target_path)
  #   falcon_main = FalconParse.new
  #   proccess = falcon_main.testedelparse(model_path, target_path)
  #   proccess
  # end

end
