require 'yaml'

class FalconScriptManager
  def initialize(file_name)
    @file = File.new(file_name, "w")
  end

  def write_to_file(line)
    @file.puts(line)
  end

  def close_file
    @file.close
  end

end


class FalconParse
  def initialize(file)
    fileContent = YAML.load_file(file)
    @infos = fileContent['infos']
    @models = fileContent['models']

    @scriptManager = FalconScriptManager.new('falcon.sh')
  end

  def create_api
    api_name = @infos['app_name']
    @scriptManager.write_to_file('echo "Creating API..."')
    @scriptManager.write_to_file("rails new #{api_name}")
    @scriptManager.write_to_file("cd #{api_name}/")
  end

  def create_models
    @scriptManager.write_to_file('echo "Creating Models..."')
    @models.each do |model, properties|
      current_model_command = "rails g scaffold #{model} "
      properties.each do |property_name, type|
        current_model_command += "#{property_name}:#{type} "
      end
      @scriptManager.write_to_file(current_model_command)
    end
  end

  def migrate_db
    @scriptManager.write_to_file('rake db:migrate')
  end
end

falcon = FalconParse.new('falcon_schema.yml')
falcon.create_api
falcon.create_models
falcon.migrate_db
