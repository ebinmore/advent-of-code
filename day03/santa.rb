class Santa

  def initialize(params = {})
    @current_position = params.fetch(:starting_position, [0,0])
    @directions = params.fetch(:directions, "")
    @locations_delivered_to = Array.new { @current_position }
  end

  def deliver_next_present(direction)
    @current_position[0] = @current_position[0] + 1 if direction == "^"
    @current_position[0] = @current_position[0] - 1 if direction == "V"
    @current_position[1] = @current_position[1] + 1 if direction == ">"
    @current_position[1] = @current_position[1] - 1 if direction == "<"
    @locations_delivered_to << @current_position

    puts "Delivering to [#{@current_position[0]}, #{@current_position[1]}]"
  end

  def deliver_all_presents
    @directions.each_char { |direction| deliver_next_present(direction) }
  end

  def deliveries
    @locations_delivered_to
  end

end