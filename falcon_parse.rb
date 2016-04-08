require 'yaml'
require_relative 'falcon_script_manager.rb'

class FalconParse

  def initialize(file)
    fileContent = YAML.load_file(file)
    @infos = fileContent['infos']
    @models = fileContent['models']
    @scriptManager = FalconScriptManager.new('falcon.sh')
  end

  def create_api
    api_name = @infos['app_name']
    rails_version = "5.0.0.beta3"
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
    @scriptManager.write_to_file("rails _#{rails_version}_ new ../#{api_name} --api")
    @scriptManager.write_to_file("cd ../#{api_name}/")
  end

  def create_models
    @scriptManager.write_to_file('echo "Creating Models..."')
    @scriptManager.write_to_file("spring stop")

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
