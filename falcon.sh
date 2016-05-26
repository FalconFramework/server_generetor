cd /Users/thiagoMB/Desktop/tabbar
mkdir falcon_generated_app
cd falcon_generated_app
source ~/.rvm/scripts/rvm
if [[ "$(rvm -v)" != *"1.27"* ]]
then
  echo "Needs rvm 1.27"
  echo "Installing rvm 1.27..."
  \curl -sSL https://get.rvm.io | bash -s stable --rails 
 echo [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" >> ~/.bash_profile
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
  rvm use ruby-2.3.0@ido --ruby-version --create
  rvm gemset use ido
  gem install rails -v 5.0.0.beta3
fi
echo "Creating API..."
rails _5.0.0.beta3_ new ido --api 
cd ido/
echo "Config JSONAPI"
echo "gem 'active_model_serializers', '~> 0.10.0.rc1'">> Gemfile
echo ActiveModel::Serializer.config.adapter = :json >> config/initializers/ams_json_adapter.rb
bundle install
echo "Creating Models..."
spring stop
rails g scaffold user name:string email:string phone_number:string wedding_date:date 
rails g scaffold friend user:references friend_id:integer 
rails g scaffold preference user:references bidget:float 
awk 'NR==2{print "has_many :friends"}1' app/models/user.rb > newfile
rm app/models/user.rb
mv newfile app/models/user.rb
awk 'NR==2{print "belongs_to  :friend, :class_name => \"User\" "}1' app/models/friend.rb > newfile
rm app/models/friend.rb
mv newfile app/models/friend.rb
rake db:migrate
awk 'NR==7{print "@users = User.where(params[:where]).offset(params[:offset]).limit(params[:limit]).order(params[:order])"}1' app/controllers/users_controller.rb > newfile
rm app/controllers/users_controller.rb
mv newfile app/controllers/users_controller.rb
sed -i.bak -e  '6d' app/controllers/users_controller.rb
rm app/controllers/users_controller.rb.bak
awk 'NR==7{print "@friends = Friend.where(params[:where]).offset(params[:offset]).limit(params[:limit]).order(params[:order])"}1' app/controllers/friends_controller.rb > newfile
rm app/controllers/friends_controller.rb
mv newfile app/controllers/friends_controller.rb
sed -i.bak -e  '6d' app/controllers/friends_controller.rb
rm app/controllers/friends_controller.rb.bak
awk 'NR==7{print "@preferences = Preference.where(params[:where]).offset(params[:offset]).limit(params[:limit]).order(params[:order])"}1' app/controllers/preferences_controller.rb > newfile
rm app/controllers/preferences_controller.rb
mv newfile app/controllers/preferences_controller.rb
sed -i.bak -e  '6d' app/controllers/preferences_controller.rb
rm app/controllers/preferences_controller.rb.bak
