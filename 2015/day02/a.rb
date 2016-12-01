require_relative 'present'
require_relative 'input'

# calculate area of all sides
# calculate area of wrapping paper needed = area of all sides + area of smallest side
# fn:
# => top, bottom = width x depth
# => front, back = width x height
# => right, left = depth x height

puts "Total wrapping paper required is #{SantasPresents::PRESENTS_TO_WRAP.map(&:wrapping_paper_required).reduce(0, &:+)} m2."