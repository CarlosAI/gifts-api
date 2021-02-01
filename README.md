# gifts_api

The project was developed with:

- Ruby '2.5.3'
- Rails 5.2

If you have any other version of Ruby, you can install and configure Ruby 2.5.3 and using rbenv to set Ruby 2.5.3 as the local version for the application.


### Configuration

The application uses the following additional libraries:

	- pg (For PostgreSQL)
	- will_paginate
	- jbuilder
	- faker


### Getting Started

Clone the repo and be sure of being on the HEAD of the master branch

After cloning the repo:
### Install the gems

```
bundle install
```
### Setup the database

1. To create and be sure that the Databases are created, run the following command

rails db:create


2. The project has a seeds.rb file to populate the database with some initial records

Run database seed data generation with the command

```
rails db:seed
```

Create test database

```
psql 

CREATE DATABASE gifts_api_test;
```
### Migrate the database

```
bundle exec rake db:migrate
```

### Start the server

You can start the server on the default port by using

```
rails s
```

Or if you need, you can specify another port by using

```
bundle exec rails s -p 3027
```

### Final Steps

Now you can start testing the app, making some request and have fun withe the app.

Please visit the API documentation so that you know and have the tools to start making a correct request to the API

[API Documentation](https://api-docs.charliebron.repl.co/)

(If you have any problem when viewing the documentation (Since it is a free Hosting) contact me)

Likewise, the project was launched on the Heroku platform, which you can also use to make API requests, just replacing the base url.

Project link on the platform:

https://api-gifts.herokuapp.com