require 'set'
require 'digest'

class HaxzorPassword

  def initialize(params = {})
    @door_id = params[:door_id]
    @password_length = 2
    @hash_criteria = '00000'
    @hash_length = @hash_criteria.length

    @password = generate_hacking_movie_password
  end

  private def generate_hacking_movie_password
    md5 = Digest::MD5.new

    index = 3231900
    password = []
    while (password.length < @password_length)
      to_be_hashed = "#{@door_id}#{index}"
      hash = md5.hexdigest(to_be_hashed)
      puts "#{hash[0, @hash_length + 1]}\t#{to_be_hashed}"
      if hash[0,@hash_length] == @hash_criteria
        password << hash[@hash_length]
        puts "#{hash[0,@hash_length + 1]} was found at index #{index}"
      end

      index += 1
    end

    password.join
  end

  def value
    @password
  end

end
