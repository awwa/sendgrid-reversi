# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Addresses" do
  describe "get_address" do
    it "no <>" do
      actual = Addresses.get_address("your@address.com")
      expect(actual).to eq("your@address.com")
    end
    it "exist <>" do
      actual = Addresses.get_address("Your Name<your@address.com>")
      expect(actual).to eq("your@address.com")
    end
    it "3 layer domain" do
      actual = Addresses.get_address("your@sub.domain.address.com")
      expect(actual).to eq("your@sub.domain.address.com")
    end
    it "invalid address" do
      actual = Addresses.get_address("your.address.com")
      expect(actual).to be(nil)
    end
  end
end
