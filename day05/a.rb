require_relative 'intern_elf'

naughty_and_nice = IO.readlines('naughty_or_nice.txt')

# to be nice:
# => need at least three vowels (ie. 3 from {aeiou})
# => needs a double letter (ie. 'xx')
# => cannot contain any of the following combinations:
#    { ab, cd, pq, xy }

three_vowels = /([aeiou].*){3,}/
double_letter = /(\w)\1/
combos = /(ab)|(cd)|(pq)|(xy)/

tests = ['ugknbfddgicrmopn', 'jchzalrnumimnmhp', 'haegwjzuvuyypxyu', 'dvszwmarrgswjxmb']

# nice:
# ugknbfddgicrmopn

# naughty:
# jchzalrnumimnmhp
# haegwjzuvuyypxyu
# dvszwmarrgswjxmb


tests.each do |name|
  puts "#{name}"
  puts "Matches three vowels? #{three_vowels.match(name) != nil}"
  puts "Contains a double letter? #{double_letter.match(name) != nil}"
  puts "Has combos? #{combos.match(name) != nil}"
  puts
end

intern_elf = InternElf.new( naughty_and_nice: naughty_and_nice,
                            nice_conditions: [three_vowels, double_letter],
                            naughty_conditions: [combos] )
intern_elf.go_through_list

puts "Total names: #{naughty_and_nice.count}"
puts "There are #{intern_elf.nice.size} nice names!"
puts "There are #{intern_elf.naughty.size} naughty names!"
