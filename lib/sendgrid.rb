# -*- encoding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "net/https"
require "rest-client"

class Sendgrid

  attr_accessor :debug_output

  def initialize(username, password, options={"turn_off_ssl_verification" => false})
    @username = username
    @password = password
    @options = options
    @debug_output = false
  end

  def parse_set(hostname, url, spam_check)
    form              = Hash.new
    form['hostname']  = hostname
    form['url']       = url
    form['spam_check'] = spam_check
    form['api_user']  = @username
    form['api_key']   = @password

    RestClient.log = $stderr if @debug_output

    headers          = Hash.new
    headers[:content_type] = :json
    response = RestClient.post 'https://api.sendgrid.com/api/parse.set.json', form, :content_type => :json, "User-Agent" => "sendgrid/#{SendgridRuby::VERSION};ruby"

    JSON.parse(response.body)
  end

  def activate_app(name)
    form              = Hash.new
    form['name']      = name
    form['api_user']  = @username
    form['api_key']   = @password

    RestClient.log = $stderr if @debug_output

    headers          = Hash.new
    headers[:content_type] = :json
    response = RestClient.post 'https://api.sendgrid.com/api/filter.activate.json', form, :content_type => :json, "User-Agent" => "sendgrid/#{SendgridRuby::VERSION};ruby"

    JSON.parse(response.body)
  end

  def filter_setup(filter)
    form              = filter.to_web_format
    form['api_user']  = @username
    form['api_key']   = @password

    RestClient.log = $stderr if @debug_output

    headers          = Hash.new
    headers[:content_type] = :json
    response = RestClient.post 'https://api.sendgrid.com/api/filter.setup.json', form, :content_type => :json, "User-Agent" => "sendgrid/#{SendgridRuby::VERSION};ruby"

    JSON.parse(response.body)
  end

end

class FilterSettings

  attr_accessor :params

  def initialize
    @params = {}
  end

  def to_web_format
    return params
  end
end
