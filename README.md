[![Build Status](https://travis-ci.org/fsaravia/monkey-mailer.png)](https://travis-ci.org/fsaravia/monkey-mailer)
[![Code Climate](https://codeclimate.com/github/fsaravia/monkey-mailer.png)](https://codeclimate.com/github/fsaravia/monkey-mailer)

Monkey Mailer
======

## Description
Monkey Mailer is a gem that allows building a service for handling an email queue, it supports priority (urgent, normal and low priorities) and is higly customizable.  
Emails can be loaded from different data sources using `loader` plugins (See below), it uses priority to determine which mails will be sent as soon as they are queued and which mails can wait  
Once loaded, emails can be sent using either SMTP or [Mailchimp's Mandril API](http://mandrill.com/), they are `adapters` and, as with `loaders`, MonkeyMailer can be easily extended to work with the email provider of your choice  
After setup, Monkey Mailer can be configured to run and process your emails in a infinite loop until you stop it, it uses the [fallen](https://github.com/inkel/fallen/) gem, to run as a daemon in your server  
The principle behind MonkeyMailer's functionality is simple, it runs an infinite loop, within that loop it asks the `adapter` for emails to send. And this is where priority becomes important:
* `Urgent` mails are loaded and sent on every iteration
* `Normal` and `Low` priority emails are loaded and sent after a certain number of iterations have passed  
Also, in order to avoid problems with your email provider, all priorities have a quota, so if there are many urgent emails to send, MonkeyMailer will only load and send a certain number on each iteration  

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

Any adapter receives its settings by setting up MonkeyMailer.configuration.adapter_options, check out each one for specific options

##Dummy loader and adapter
Test adapter and loader are provided within MonkeyMailer so you can play with them:  

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

## Building your own loader
It is painfully easy to write your own loader, just create a class inside `MonkeyMailer::Loaders` module and define this three methods:
```ruby
  def initialize(opts)
    # The content of MonkeyMailer.loader_options will be available on opts
  end

  def find_emails(priority, quota)
    # Return an array of emails with the given priority with a limit of quota
  end

  def delete_email(end)
    # Delete the email from your data storage, this method will only be called if email sent
    # was successful
  end
```

## List of known loaders:

* [mm-data_mapper](https://github.com/fsaravia/mm-data_mapper): Uses the DataMapper gem to load emails from a database

## License
See the `UNLICENSE` file included with this gem distribution.

