

class Addresses

  def self.get_address(value)
    # TODO パターン認識方法の改善。最初に見つかったメールアドレスっぽい文字列を返す
    regex = %r{[a-zA-Z0-9!$&*.=^`|~#%'+\/?_{}-]+@([a-zA-Z0-9_-]+\.)+[a-zA-Z]{2,4}}
    value =~ regex
    $&
  end

end
