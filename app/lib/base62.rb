class Base62
  RANGE = (56800235584..704423425546998022968330264616370175)
  CHARS = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

  def self.encode(numeric)
    numeric = numeric.abs
    string = numeric == 0 ? '0' : ''

    while numeric.send(:>, 0)
      string << CHARS[numeric.modulo(62)]
      numeric /= 62
    end
    string.reverse
  end

  def self.decode(string)
    string, total = string.reverse.split(''), 0

    string.each_with_index do |char, index|
      total += CHARS.index(char)*(62**index)
    end
    total
  end

  def self.token
    encode(rand(RANGE))
  end
end

