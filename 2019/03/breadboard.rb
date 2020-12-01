require 'byebug'

# breadboard is a representation of the 2-D grid (x,y) that the wires
# run through. It helps us find the intersection of the wires.
class Breadboard
  attr_accessor :wire_one,
                :wire_two,
                :intersections

  def initialize(trace_one, trace_two)
    # setup the grid -- trace_one & trace_two are arrays of instructions
    @wire_one = Wire.new(trace_one)
    @wire_two = Wire.new(trace_two)

    @intersections = []

    puts "wire_one: #{wire_one.line_segments}"
    puts
    puts "wire_two: #{wire_two.line_segments}"
  end

  def find_intersections
    # let's just brute force this and check each line segment with all the
    # line segments in the other wire
    wire_one.line_segments.each do |source|
      # find the dimension the line is travelling in
      # ie. the other dimesion will be static (difference is 0)
      dx = (source[:a][0] - source[:b][0]).abs
      dy = (source[:a][1] - source[:b][1]).abs

      range_x = get_range(source[:a][0], source[:b][0])
      range_y = get_range(source[:a][1], source[:b][1])

      # the stationary dimension is the range with only one element
      if dx == 0
        # select all the line where y is static
        may_intersect = wire_two.line_segments.select do |seg|
          seg[:a][1] == seg[:b][1]
        end

        # now the line segments that may intersect, check if the does
        intersecting_segments = may_intersect.select do |seg|
          get_range(seg[:a][0], seg[:b][0]).cover?(range_x.first) && range_y.cover?(seg[:a][1])
        end

        intersecting_segments.each do |seg|
          # get the intersecting point of the two line segments
          intersections << {
            point: [range_x.first, seg[:a][1]],
            line_segments: { one: source, two: seg }
          } unless [range_x.first, seg[:a][1]] == [0, 0]
        end
      end

      # repeat for a static y dimension
      if dy == 0
        # select all the line where x is static
        may_intersect = wire_two.line_segments.select do |seg|
          seg[:a][0] == seg[:b][0]
        end

        # now the line segments that may intersect, check if the does
        intersecting_segments = may_intersect.select do |seg|
          range_x.cover?(seg[:a][0]) && get_range(seg[:a][1], seg[:b][1]).cover?(range_y.first)
        end

        intersecting_segments.each do |seg|
          # get the intersecting point of the two line segments
          intersections << {
            point: [seg[:a][0], range_y.first],
            line_segments: { one: source, two: seg }
          } unless [seg[:a][0], range_y.first] == [0, 0]
        end
      end
    end
    puts "Number of intersections: #{intersections.count}"
    puts 'Intersections:'
    intersections.each do |intersection|
      puts "point: #{intersection[:point]}"
      puts "\tone: #{intersection[:line_segments][:one]}"
      puts "\ttwo: #{intersection[:line_segments][:two]}"
    end
  end

  def get_range(a, b)
    ([a, b].min)..([a, b].max)
  end
end
