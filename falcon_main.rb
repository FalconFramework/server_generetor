require_relative 'falcon_parse.rb'

falcon = FalconParse.new('falcon_schema.yml')
falcon.create_api
falcon.create_models
falcon.migrate_db
