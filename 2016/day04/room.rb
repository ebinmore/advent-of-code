
class Room

  def initialize(encrypted_name)
    puts
    @encrypted_name = encrypted_name
    puts "encrypted name = #{@encrypted_name}"
    components = encrypted_name.split("-")

    @sector_id, @checksum = components.pop.split("[")
    @checksum = @checksum.chop
    puts "sector_id = #{@sector_id}"
    puts "checksum = #{@checksum}"

    @letters = components.map(&:chars).flatten
    puts "letters = #{@letters}"
  end

  def sector_id
    @sector_id.to_i
  end

  def checksum
    @checksum
  end

  def valid?
    decrypted = decrypt

    puts "#{@encrypted_name} decrypted to #{decrypted} which #{decrypted == @checksum ? 'matches' : 'does not match'} the checksum #{@checksum}."

    decrypted == @checksum
  end

  def decrypt
    commonality = @letters.group_by { |i| i } # produces { "a": [a,a,a,a], "b": [b,b,b], ... "z": [z]}
    commonality.update(commonality) { |key, value| value.count } # { "a": 4, "b": 3, ..., "z": 1 }
    puts "commonality = #{commonality}"
    # takes { a: 5, b: 2, c: 3, d: 3, e: 3} => {5: [a], 2: [b], 3: [c, d, e]}
    commonality = commonality.reduce({}) do |hash, (key, value)|
      hash[value] = [] unless hash.keys.include? value
      hash[value] << key
      hash
    end
    commonality.sort.reverse # sorts by key highest to lowest
    commonality.update(commonality) { |key, value| value.sort } # sorts each value array
    commonality.values.flatten[0..(@checksum.length - 1)].join
  end

end
