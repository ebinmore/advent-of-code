
class Room

  def initialize(encrypted_name)
    puts
    @encrypted_name = encrypted_name
    puts "encrypted name = #{@encrypted_name}"

    @sector_id, @checksum = encrypted_name.split("-").pop.split("[")
    @checksum = @checksum.chop
    puts "sector_id = #{@sector_id}"
    puts "checksum = #{@checksum}"
  end

  def sector_id
    @sector_id.to_i
  end

  def checksum
    @checksum
  end

  def valid?
    # @checksum is the provided
    # checksum is the calculated
    checksum = compute_checksum

    puts "#{@encrypted_name} decrypted to #{checksum} which #{checksum == @checksum ? 'matches' : 'does not match'} the checksum #{@checksum}."

    checksum == @checksum
  end

  def compute_checksum
    letters = @encrypted_name.split("-").map(&:chars).flatten
    puts "letters = #{letters}"

    commonality = letters.group_by { |i| i } # produces { "a": [a,a,a,a], "b": [b,b,b], ... "z": [z]}
    commonality.update(commonality) { |key, value| value.count } # { "a": 4, "b": 3, ..., "z": 1 }
    puts "letter frequency = #{commonality}"
    # takes { a: 5, b: 2, c: 3, d: 3, e: 3} => {5: [a], 2: [b], 3: [c, d, e]}
    commonality = commonality.reduce({}) do |hash, (key, value)|
      hash[value] = [] unless hash.keys.include? value
      hash[value] << key
      hash
    end
    puts "frequency of letters = #{commonality}"
    commonality = commonality.sort.reverse.to_h # sorts by key highest to lowest
    puts "ordered highest to lowest frequency = #{commonality}"
    commonality.update(commonality) { |key, value| value.sort } # sorts each value array
    commonality.values.flatten[0..(@checksum.length - 1)].join
  end

  def decrypt
    $stdout.sync
    words = @encrypted_name.split("-")
    words.pop # get rid of the sector_id & checksum

    decrypted = []
    alphabet = "abcdefghijklmnopqrstuvwxyz".chars
    words.each do |word|
      print "translating #{word} to "
      decrypted_word = []
      word.downcase.each_char do |char|
        decrypted_word << alphabet[(alphabet.index(char) + 1) % alphabet.count]
        print decrypted_word
      end
      print "\n"
      decrypted << decrypted_word
    end

    decrypted.map{ |word| word.join }.join(" ")
  end
end
