# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Main" do
  include Rack::Test::Methods
  def app
    @app ||= Reversi::Main
  end

  describe "post /game" do
    before { post '/game' }
    subject { last_response }
    it "Validate normal response" do
      should be_ok
    end
    it "Validate the response message is 'Fail to parse to and from address'" do
      expect(subject.body).to eq('Fail to parse to and from address')
    end
  end

  describe "post /event" do
    before { post '/event'}
    subject { last_response }
    it "Validate normal response" do
      should be_ok
    end
    it "Validate the response message is 'Success'" do
      expect(subject.body).to eq('Success')
    end
  end
end
