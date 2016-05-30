# FalconFactory

Welcome to your new gem!

## Installation

Add this line to your application's Gemfile:

`REQUIRES ruby-2.3.0`

```ruby
gem 'falcon_factory'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install falcon_factory

## Usage

This is the Falcon server generator.

* 1. Define your falcon_schema.yml. (infos, models, ...)![Screen_Shot_2016-05-05_at_9.02.07_PM](/uploads/f37868c49239e02e0bcb2f50a740cdfe/Screen_Shot_2016-05-05_at_9.02.07_PM.png)

`user: ` is a model name.

`name:` is a property and `string` is the type.

`friend:` is a relation with friend model identified by the type `has_many`.

`friend: belongs_to => user` is a relation with name `friend` and a class defined `user`
* 2. run `falcon_factory generate -m /falcon_schema.yml -t /my_generated_app_path`. This will generate a falcon.sh script witch will create you server
* 3. run cd my_generated_app_path
* 4. run rails s
* 5. Enjoy your api

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [falconframework.com/falcon_factory](https://falconframework.com/falcon_factory).

## Contributing
