class Taxi
  ORIGIN = [0,0]
  DIRECTIONS = {north: [1,0], east: [0,1], south: [-1,0], west: [0, -1]}

  def initialize(params = {starting_location: ORIGIN, starting_direction: :north})
    @current_facing = params[:starting_direction]
    @current_position = params[:starting_location]
  end

  def turn_left
    print "currently facing #{@current_facing.to_s}, turning left "
    @current_facing = DIRECTIONS.keys[DIRECTIONS.keys.index(@current_facing) - 1]
    puts "to face  #{@current_facing.to_s}"
  end

  def turn_right
    print "currently facing #{@current_facing.to_s}, turning right "
    @current_facing = DIRECTIONS.keys[(DIRECTIONS.keys.index(@current_facing) + 1) % DIRECTIONS.keys.count]
    puts "to face #{@current_facing.to_s}"
  end

  def travel(distance)
    x = DIRECTIONS[@current_facing][0] * distance
    y = DIRECTIONS[@current_facing][1] * distance
    print "currently at #{@current_position}, travelling [#{x}, #{y}] to "
    @current_position = [@current_position[0] + x, @current_position[1] + y]
    puts "#{@current_position}"
  end

  def current_facing
    @current_facing
  end

  def current_position
    @current_position
  end
end
