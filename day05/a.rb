
naughty_or_nice = IO.readlines('naughty_or_nice.txt')

# to be nice:
# => need at least three vowels (ie. 3 from {aeiou})
# => needs a double letter (ie. 'xx')
# => cannot contain any of the following combinations:
#    { ab, cd, pq, xy }

three_vowels = /([aeiou].*){3,}/
double_letter = /\w{2}/
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
