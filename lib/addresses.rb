# -*- encoding: utf-8 -*-

module Addresses

  def get_address(value)
    # TODO improve email address pattern identification
    regex = %r{[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@([a-zA-Z0-9_-]+\.)+[a-zA-Z]{2,4}}
    value =~ regex
    $&
  end

  module_function :get_address

end
