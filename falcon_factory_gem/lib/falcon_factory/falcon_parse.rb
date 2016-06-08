require 'yaml'
require_relative 'falcon_script_manager.rb'
require 'active_support/inflector'

class FalconParse

  def initialize(model_path,target_path)
    fileContent = YAML.load_file(model_path)
    @infos = fileContent['infos']
    @models = fileContent['models']
    @scriptManager = FalconScriptManager.new
    @relations_types =  /"|has_many|belongs_to|has_one|"/
    @target_path = target_path
  end

  def create_api
    api_name = @infos['app_name']
    rails_version = "5.0.0.rc1"

    @scriptManager.run_line("cd #{@target_path}")
    @scriptManager.run_line("mkdir #{@target_path}/falcon_generated_app")
    @target_path =  "#{@target_path}/falcon_generated_app"

    check_environment_string ='
if [[ "$(rails -v)" != *"5.0.0.rc1"* ]]
then
  echo "Needs Rails 5.0.0.rc1"
  echo "Installing Rails 5.0.0.rc1"
  gem install rails -v ' + rails_version + '
fi
'
    @scriptManager.run_line(check_environment_string)
    @scriptManager.run_line('echo "Creating API..."')
    @scriptManager.run_line("rails _#{rails_version}_ new  #{@target_path}/#{api_name} --api ")
    @target_path =  "#{@target_path}/#{api_name}"

    Dir.chdir("#{@target_path}")

    @scriptManager.run_line('echo "Config JSONAPI"')
    serializer_gem = "'active_model_serializers'"
    serializer_gem_version = "'~> 0.10.0.rc1'"
    gem_to_add = "gem #{serializer_gem}, #{serializer_gem_version}"
    command_to_add_gem = 'echo "' + gem_to_add + '"' + ">> #{@target_path}/Gemfile"
    @scriptManager.run_line(command_to_add_gem)
    @scriptManager.run_line("echo ActiveModel::Serializer.config.adapter = :json >> #{@target_path}/config/initializers/ams_json_adapter.rb")
    @scriptManager.run_line("bundle install")
  end

  def create_models
    @scriptManager.run_line('echo "Creating Models..."')
    @scriptManager.run_line("spring stop")

    @models.each do |model, properties|
      current_model_command = "rails g scaffold #{model} "
      properties.each do |property_name, type|
        if  @relations_types === type
          if type == "belongs_to"
            current_model_command += "#{property_name}:references "
          elsif type.include?("belongs_to =>")
            current_model_command += "#{property_name}_id:integer "
          end
        else
          current_model_command += "#{property_name}:#{type} "
        end
      end
      @scriptManager.run_line(current_model_command)
    end
  end

  def create_relationships
    @models.each do |model, properties|
      properties.each do |property_name, type|
        if  @relations_types === type
          if type == "has_many"
            pluralized_property_name = property_name.pluralize
            add_relation_line_content = "#{type} :#{pluralized_property_name}"
            @scriptManager.run_script_to_add_relation_line_in_model(@target_path,model,add_relation_line_content)
          elsif type.include?("belongs_to =>")
            class_name_string = (type.split(' => ')[1]).capitalize
            relation_name = type.split('=>')[0]
            add_relation_line_content = "#{relation_name} :friend, :class_name => \\\"#{class_name_string}\\\" "
            @scriptManager.run_script_to_add_relation_line_in_model(@target_path,model,add_relation_line_content)
          elsif type != "belongs_to"
            add_relation_line_content = "#{type} :#{property_name}"
            @scriptManager.run_script_to_add_relation_line_in_model(@target_path,model,add_relation_line_content)
          end
        end
      end
    end
  end

  def create_query_support
    @models.each do |model, properties|
      @scriptManager.run_script_to_add_query_support(@target_path,model)
    end
  end

  def migrate_db
    @scriptManager.run_line("rake db:migrate")
  end
end
