# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Addresses" do
  describe "アドレス抽出検査" do
    it "<>なし" do
      actual = Addresses.get_address("your@address.com")
      actual.should == "your@address.com"
    end
    it "<>あり" do
      actual = Addresses.get_address("Your Name<your@address.com>")
      actual.should == "your@address.com"
    end
    it "3階層ドメイン" do
      actual = Addresses.get_address("your@sub.domain.address.com")
      actual.should == "your@sub.domain.address.com"
    end
    it "不正なアドレス" do
      actual = Addresses.get_address("your.address.com")
      actual.should == nil
    end
  end
end
