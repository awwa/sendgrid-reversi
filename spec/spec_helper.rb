require File.join(File.dirname(__FILE__), '..', 'main.rb')
require File.join(File.dirname(__FILE__), '..', 'addresses.rb')
require File.join(File.dirname(__FILE__), '..', 'game.rb')
require File.join(File.dirname(__FILE__), '..', 'db_access.rb')
require File.join(File.dirname(__FILE__), '..', 'mailer.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
