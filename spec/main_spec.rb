# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Main" do
  include Rack::Test::Methods
  def app
    @app ||= Sinatra::Application
  end

  describe "レスポンス検査" do
    describe "/game へのアクセス" do
      before { post '/game' }
      subject { last_response }
      it "正常なレスポンス" do
        should be_ok
      end
      it "Fail to parse to and from addressと出力されること" do
        expect(subject.body).to eq('Fail to parse to and from address')
      end
    end
  end
end
