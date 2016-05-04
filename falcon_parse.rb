require 'yaml'
require_relative 'falcon_script_manager.rb'
require 'active_support/inflector'

class FalconParse


  def initialize(file)
    fileContent = YAML.load_file(file)
    @infos = fileContent['infos']
    @models = fileContent['models']
    @scriptManager = FalconScriptManager.new('falcon.sh')
    @relations_types = ["has_many", "belongs_to", "has_one"]
  end

  def create_api
    api_name = @infos['app_name']
    rails_version = "5.0.0.beta3"

    @scriptManager.write_to_file("cd ..")
    @scriptManager.write_to_file("mkdir falcon_generated_app")
    @scriptManager.write_to_file("cd falcon_generated_app")

    check_environment_string ='source ~/.rvm/scripts/rvm
if [[ "$(rvm -v)" != *"1.27"* ]]
then
  echo "Needs rvm 1.27"
  echo "Installing rvm 1.27..."
  \curl -sSL https://get.rvm.io | bash -s stable --rails ' + "\n " +
  'echo [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" >> ~/.bash_profile
fi

if [[ "$(rvm use ruby-2.3.0)" == *"is not installed"* ]]
then
  echo "Needs ruby 2.3.0"
  echo "Installing ruby 2.3.0..."
  rvm install ruby-2.3.0
  rvm use ruby-2.3.0
fi

if [[ "$(rails -v)" != *"5.0"* ]]
then
  echo "Needs Rails 5.0"
  echo "Installing Rails 5.0"
  rvm use ruby-2.3.0@' + "#{api_name}" + ' --ruby-version --create
  rvm gemset use ' + "#{api_name}" + '
  gem install rails -v ' + rails_version + '
fi
'
    @scriptManager.write_to_file(check_environment_string)
    @scriptManager.write_to_file('echo "Creating API..."')
    @scriptManager.write_to_file("rails _#{rails_version}_ new #{api_name} --api ")
    @scriptManager.write_to_file("cd #{api_name}/")

    @scriptManager.write_to_file('echo "Config JSONAPI"')
    serializer_gem = "'active_model_serializers'"
    serializer_gem_version = "'~> 0.10.0.rc1'"
    gem_to_add = "gem #{serializer_gem}, #{serializer_gem_version}"
    command_to_add_gem = 'echo "' + gem_to_add + '"' + ">> Gemfile"
    @scriptManager.write_to_file(command_to_add_gem)
    @scriptManager.write_to_file("echo ActiveModel::Serializer.config.adapter = :json >> config/initializers/ams_json_adapter.rb")
    @scriptManager.write_to_file("bundle install")
  end

  def create_models
    @scriptManager.write_to_file('echo "Creating Models..."')
    @scriptManager.write_to_file("spring stop")

    @models.each do |model, properties|
      current_model_command = "rails g scaffold #{model} "
      properties.each do |property_name, type|
        if  @relations_types.include?(type)
          if type == "belongs_to"
            current_model_command += "#{property_name}:references "
          end
        else
          current_model_command += "#{property_name}:#{type} "
        end
      end
      @scriptManager.write_to_file(current_model_command)
    end
  end

  def create_relationships
    @models.each do |model, properties|
      properties.each do |property_name, type|
        if  @relations_types.include?(type)
          if type == "has_many"
            pluralized_property_name = property_name.pluralize
            add_relation_line_content = "#{type} :#{pluralized_property_name}"
            add_relation_line_in_model(model,add_relation_line_content)
          elsif type != "belongs_to"
            add_relation_line_content = "#{type} :#{property_name}"
            add_relation_line_in_model(model,add_relation_line_content)
          end
        end
      end
    end
  end

  def add_relation_line_in_model(model,line_content)
    model_file_name = "app/models/#{model}.rb"
    add_relation_command = "awk 'NR==2{print \"#{line_content}\"}1' #{model_file_name} > newfile"
    @scriptManager.write_to_file(add_relation_command)
    add_relation_command = "rm #{model_file_name}"
    @scriptManager.write_to_file(add_relation_command)
    add_relation_command = "mv newfile #{model_file_name}"
    @scriptManager.write_to_file(add_relation_command)
  end

  def create_query_support
    @models.each do |model, properties|
      add_query_support(model)
    end
  end

  def add_query_support(model_name)
    model_capitalized = model_name.slice(0,1).capitalize + model_name.slice(1..-1)
    query_support_line_content =     "@#{model_name.pluralize} = #{model_capitalized}.where(params[:where]).offset(params[:offset]).limit(params[:limit]).order(params[:order])"
    controller_file_name = "app/controllers/#{model_name.pluralize}_controller.rb"
    add_query_command = "awk 'NR==7{print \"#{query_support_line_content}\"}1' #{controller_file_name} > newfile"
    @scriptManager.write_to_file(add_query_command)
    add_query_command = "rm #{controller_file_name}"
    @scriptManager.write_to_file(add_query_command)
    add_query_command = "mv newfile #{controller_file_name}"
    @scriptManager.write_to_file(add_query_command)
    add_query_command = "sed -i.bak -e  '6d' #{controller_file_name}"
    @scriptManager.write_to_file(add_query_command)
    add_query_command = "rm #{controller_file_name}.bak"
    @scriptManager.write_to_file(add_query_command)

  end

  def migrate_db
    @scriptManager.write_to_file('rake db:migrate')
  end
end
