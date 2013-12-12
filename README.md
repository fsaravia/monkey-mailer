Monkey Mailer
======

## Description
Monkey Mailer is a gem that allows handling a mailing queue, it supports email priority (urgent, normal and low priorities) and is higly customizable.  
Emails can be loaded from different data sources using Loader gems (See below), feel free to contribute a loader with your preferred datastore!  
Once loaded, emails can be sent using either SMTP or [Mailchimp's Mandril API](http://mandrill.com/)  
After setup, Monkey Mailer can be configured to run and process your emails in a infinite loop until you stop it, it uses the [fallen](https://github.com/inkel/fallen/) gem, to run as a daemon in your server

## Instalation
    gem install monkey-mailer

### or on your gemfile
    gem 'monkey-mailer'

## About Loaders
Loaders are plugin gems that can be attached to Monkey Mailer in order to support different data storage methods. This gem does not ship with any usable loader out of the box because they usually have a lot of dependencies and we are trying to keep it simple for  everyone, so just choose an existent loader (or build and contribute your own if you may).  
One you've chosen your preferred loader, just add it to the configuration options and you're good to go!

## Configuration example
```ruby
  require 'monkey-mailer'
  require 'mm-data_mapper' # Or any other loader of your choice

  module MyPostman
    extend MonkeyMailer

    MonkeyMailer.configure do |config|
      config.adapter = 'mandrilapi', # Method used to send emails
      config.mandril_api_ley = 'YOUR_API_KEY'
      config.smtp = {} #If you prefer to use smtp just put your settings here and set the correct adapter
      config.loader = 'data_mapper' #Uses the loader on mm-data_mapper gem to load emails from a database
      config.urgent_quota = 100 # How many urgent mails to send on each iteration
      config.normal_quota = 50 # How many normal priority emails to send on each iteration
      config.low_quota = 2 # How many low priority emails to send on each iteration
      config.normal_sleep = 1 # How many iterations to skip when sending normal priority emails
      config.low_sleep = 2 # How many iterations to skip when sending low priority emails
      config.sleep = 5 # How many seconds between iterations Monkey Mailer should sleep
      config.data_mapper_options = {} # Loader's specific options (any value called loader_name_options is allowed and sent when calling loader.new method)
    end
  end
```

## Put it to work!
Once you have finished configuring it, just call
```ruby
  ruby my_postman.rb start  
```
And you're good to go  
More information about daemonizing Monkey Mailer can be found on the [fallen](https://github.com/inkel/fallen/) README, or just call
```
  ruby my_postman.rb usage
```


