require_relative 'present'
require_relative 'input'

puts "Total ribbon required is #{SantasPresents::PRESENTS_TO_WRAP.map(&:ribbon_required).reduce(0, &:+)} m."