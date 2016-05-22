# How to use it?

This is the Falcon server generator.

* 1. run git clone git@gitlab.com:FalconTeam/server_generetor.git
* 2. Define your falcon_schema.yml. (infos, models, ...)![Screen_Shot_2016-05-05_at_9.02.07_PM](/uploads/f37868c49239e02e0bcb2f50a740cdfe/Screen_Shot_2016-05-05_at_9.02.07_PM.png)

`user: ` is a model name.

`name:` is a property and `string` is the type.

`friend:` is a relation with friend model identified by the type `has_many`.

`friend: belongs_to => user` is a relation with name `friend` and a class defined `user` 

* 3. run `ruby falcon_main.rb`. This will generate a falcon.sh script witch will create you server 
* 4. run `bash falcon.sh`. This will generate a application based on your schema. If you dont have necessary tools to generate a server, this script will install them, this can take some minutes.
* 5. run cd ..
* 6. run cd falcon_generated_app
* 7. run cd your_app_name
* 8. run rails s
* 9. Enjoy your api
