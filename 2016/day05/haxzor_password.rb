require 'digest'

class HaxzorPassword

  def initialize(params = {})
    @door_id = params[:door_id]
    @password_length = 8
    @hash_criteria = '00000'
    @hash_length = @hash_criteria.length
    @simple_password = false
    @linear_password, @ordinal_password = generate_hacking_movie_password
  end

  private def generate_hacking_movie_password
    md5 = Digest::MD5.new

    index = 1
    part_a, part_b = [], []
    while !enough_data_for_password?(part_a)
      to_be_hashed = "#{@door_id}#{index}"
      hash = md5.hexdigest(to_be_hashed)
      puts "#{hash[0, @hash_length + 2]}\t#{to_be_hashed}"
      if hash[0,@hash_length] == @hash_criteria
        part_a << hash[@hash_length]
        part_b << hash[@hash_length + 1] # value to use for the wargames password, not in position
        puts "#{hash[0,@hash_length + 2]} was found at index #{index}"
      end

      index += 1
    end

    [linear_password(part_a), ordinal_password(part_a, part_b)]
  end

  private def enough_data_for_password?(data)
    if @simple_password
      data.count >= @password_length
    else
      (0..@password_length-1).reduce(true) { |has_all, ordinal| has_all && data.include?(ordinal) }
    end
  end

  private def linear_password(values)
    values.join
  end

  private def ordinal_password(positions, values)
    password = []
    positions.each do |position|
      password[position.hex] = values[position.hex]
    end

    password[0..@password_length].join
  end

  def linear
    @linear_password
  end

  def ordinal
    @ordinal_password
  end

end
