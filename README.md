[![Build Status](https://travis-ci.org/fsaravia/monkey-mailer.png)](https://travis-ci.org/fsaravia/monkey-mailer)
[![Code Climate](https://codeclimate.com/github/fsaravia/monkey-mailer.png)](https://codeclimate.com/github/fsaravia/monkey-mailer)

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
Loaders are plugin gems that can be attached to Monkey Mailer in order to support different data storage methods. This gem does not ship with any usable loader out of the box because they usually have a lot of dependencies and we are trying to keep it simple for  everyone, so just choose an existent loader (or build and contribute your own if you may, it's easy!).  
One you've chosen your preferred loader, just add it to the configuration options and you're good to go!  
To set up a loader all you need is doing something like this:
```ruby
  MonkeyMailer.configuration.loader = MonkeyMailer::Loaders::Dummy # Set up your loader of choice
  MonkeyMailer.configuration.loder_options = {} #Loader's specific options
```

## Adapters
Adapters are classes that send your emails using different providers. MonkeyMailer provides two usable adapters that you can use, more loaders can be easily added:

* `MonkeyMailer::Adapters::MandrilAPI`
* `MonkeyMailer::Adapters::Smtp`

Any adapter receives its settings by setting up MonkeyMailer.configuration.adapter_options, check out each loader for specific options

##Dummy loader and adapter
Test adapter and loader are provided within MonkeyMailer so you can play with them for testing purposes:  

* Dummy loader: `MonkeyMailer::Loaders::Dummy` # It generates random emails for adapters to consume  
* Dummy adapter: `MonkeyMailer::Adapters::Dummy` # It just displays the email content on stdout  

## Usage Example
```ruby
  require 'monkey-mailer'
  require 'mm-data_mapper' # Or any other loader of your choice

  module MyPostman
    extend MonkeyMailer

    MonkeyMailer.configure do |config|
      config.adapter = MonkeyMailer::Adapters::MandrilAPI, # Method used to send emails
      config.adapter_options = {:mandril_api_key => 'YOUR_API_KEY'}
      config.loader = MonkeyMailer::Loaders::DataMapper #Uses the loader on mm-data_mapper gem to load emails from a database
      config.loader_options = {
        'default' => {
        :adapter => 'mysql',
        :user => 'monkey-mailer',
        :password => 'monkey_mailer_dev',
        :database => 'monkey_mailer_test'
        }
      }
      config.urgent_quota = 100 # How many urgent mails to send on each iteration
      config.normal_quota = 50 # How many normal priority emails to send on each iteration
      config.low_quota = 2 # How many low priority emails to send on each iteration
      config.normal_sleep = 1 # How many iterations to skip when sending normal priority emails
      config.low_sleep = 2 # How many iterations to skip when sending low priority emails
      config.sleep = 5 # How many seconds between iterations Monkey Mailer should sleep
    end
  end

  MyPostman.start! # You can also call MyPostman.daemonize! to dettach the process and let it run on background
```
Check out [fallen's readme](https://github.com/inkel/fallen#control-your-daemon) for more info on how to control the daemon behaviour

## CLI support
MonkeyMailer can use [`Fallen::CLI`](https://github.com/inkel/fallen#cli-support) in order to support command line arguments (and work like a real daemon!), just extend your Module from `Fallen::CLI` and do something like this:

```ruby

case Clap.run(ARGV, MyPostman.cli).first

when "start"
  MyPostman.start!
when "stop"
  MyPostman.stop!
when "usage", "help"
  puts MyPostman.fallen_usage
end
```

## Contributions
Contributions are very welcome using the well known fork -> hack -> test -> push -> pull request  
You can also build your own loader gem, we have thought of some ideas about loaders that many people will find usefull:  

* mm-activerecord  
* mm-json  
* mm-yaml  
* mm-redis  
* mm-your-storage-of-choice  

## License
See the `UNLICENSE` file included with this gem distribution.

