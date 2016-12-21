
class Room

  def initialize(encrypted_name)
    @encrypted_name = encrypted_name
    @sector_id, @checksum = encrypted_name.split("-").pop.split("[")
    @checksum = @checksum.chop
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
    checksum == @checksum
  end

  def compute_checksum
    letters = @encrypted_name.split("-").map(&:chars).flatten

    commonality = letters.group_by { |i| i } # produces { "a": [a,a,a,a], "b": [b,b,b], ... "z": [z]}
    commonality.update(commonality) { |key, value| value.count } # { "a": 4, "b": 3, ..., "z": 1 }

    # takes { a: 5, b: 2, c: 3, d: 3, e: 3} => {5: [a], 2: [b], 3: [c, d, e]}
    commonality = commonality.reduce({}) do |hash, (key, value)|
      hash[value] = [] unless hash.keys.include? value
      hash[value] << key
      hash
    end
    commonality = commonality.sort.reverse.to_h # sorts by key highest to lowest
    commonality.update(commonality) { |key, value| value.sort } # sorts each value array
    commonality.values.flatten[0..(@checksum.length - 1)].join
  end

  def decrypt
    words = @encrypted_name.split("-")
    words.pop # get rid of the sector_id & checksum

    decrypted = []
    alphabet = "abcdefghijklmnopqrstuvwxyz".chars
    words.each do |word|
      decrypted_word = []
      word.downcase.each_char do |char|
        decrypted_word << alphabet[(alphabet.index(char) + sector_id) % alphabet.count]
      end
      decrypted << decrypted_word
    end

    decrypted.map{ |word| word.join }.join(" ")
  end
end
