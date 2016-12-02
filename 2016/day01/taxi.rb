class Taxi
  ORIGIN = [0,0]
  DIRECTION = {north: [1,0], east: [0,1], south: [-1,0], west: [0, -1]}

  def initialize(params = {starting_location: ORIGIN, starting_direction: :north})
    @current_facing = params[:starting_direction]
    @current_position = params[:starting_location]
  end

  def turn_left
    @current_facing = DIRECTION.keys[DIRECTIONS.keys.index(@current_facing) - 1]
  end

  def turn_right
    @current_facing = DIRECTION.keys[DIRECTION.keys.index(@current_facing) + 1]
  end

  def travel(distance)
    x = DIRECTION[@current_facing][0] * distance
    y = DIRECTION[@current_facing][1] * distance
    @current_position = [@current_position[0] + x, @current_position[1] + y]
  end

  def current_facing
    @current_facing
  end

  def current_position
    @current_position
  end
end
