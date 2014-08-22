# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Main" do
  include Rack::Test::Methods
  def app
    @app ||= Reversi::Main
  end

  describe "Access to /game" do
    before { post '/game' }
    subject { last_response }
    it "Validate normal response" do
      should be_ok
    end
    it "Validate the response message is 'Fail to parse to and from address'" do
      expect(subject.body).to eq('Fail to parse to and from address')
    end
  end
end
