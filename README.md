# FalconFactory

Welcome to your new gem!

## Installation

`REQUIRES RUBY > 2.3.0 ` -> [Ruby install tutorial](https://gorails.com/setup/ubuntu/16.04)


Download falcon gem: [falcon_factory](https://www.dropbox.com/sh/4gi6eceh57xbg5d/AADvn72mgskCpZ2X_6dgOCVPa?dl=0).

install it yourself as:

    $ gem install falcon_factory-0.0.1.gem

## Usage

This is the Falcon server generator.

###  1. For generate your server you just need to define your falcon_schema.yml. (infos, models, ...)

# Pay atention with the identation, yml is super thorough with this.

``` yml 
infos:
  app_name: 'Great-App' 

models:
  user: #<--------- `user` is the model name -------->
    name: string
    email: string
    phone_number: string
    birth_date: date  #<--------- `birth_date` is the property name --------> `date` is the property type. 
    friend: has_many  #<--------- `friend` is the name of another model --------> `has_many` is the name of the relation point
  friend:
    user: belongs_to #<--------- `user` is the name of another model --------> `belongs_to` is the name of the relation point
    friend: belongs_to => user  #<--------- `friend` is the property name --------> `belongs_to` is the name of the relation point --------> `user` is the relation destination model
  preference:
    user: belongs_to
    bidget: float
```
This model represent this DB 

![DB](https://gitlab.com/FalconTeam/artefatos/raw/master/Desenho_de_Software/server_factory_sample.png)


###  2. run `falcon_factory generate -m your_falcon_schema_file.yml -t existent_folder_to_save_de_server`. This will generate a falcon.sh script witch will create you server
###  3. run `cd my_generated_app_path/falcon_generated_app/my_app_name`
###  4. run `rails s`

###  5. Enjoy your api

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [falconframework.com/falcon_factory](https://falconframework.com/falcon_factory).

## Contributing
