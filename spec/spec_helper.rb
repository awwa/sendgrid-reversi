require File.join(File.dirname(__FILE__), '../lib', 'main.rb')
require File.join(File.dirname(__FILE__), '../lib', 'addresses.rb')
require File.join(File.dirname(__FILE__), '../lib', 'game.rb')
require File.join(File.dirname(__FILE__), '../lib', 'db_access.rb')
require File.join(File.dirname(__FILE__), '../lib', 'mailer.rb')
require File.join(File.dirname(__FILE__), '../lib', 'settings.rb')
require File.join(File.dirname(__FILE__), '../lib', 'game_collection.rb')
require File.join(File.dirname(__FILE__), '../lib', 'app_config.rb')
require File.join(File.dirname(__FILE__), '../lib', 'app_config_collection.rb')
require File.join(File.dirname(__FILE__), '../lib', 'configure.rb')
require File.join(File.dirname(__FILE__), '../lib', 'sendgrid.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
 
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
