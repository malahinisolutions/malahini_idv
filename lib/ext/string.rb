class String

  DEFAULT_TOKEN_LENGTH = 50
  INVALID_LENGTH_EXCEPTION = "Invalid length for token"

  def self.generate_string(length=DEFAULT_TOKEN_LENGTH)
    length = length.to_i
    raise Exception.new(INVALID_LENGTH_EXCEPTION) if length < 0
    o = [('a'..'z'), ('A'..'Z'), (1..9)].map { |i| i.to_a }.flatten
    string = (0...length).map { o[rand(o.length)] }.join
  end

end