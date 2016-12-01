require 'set'

class Santa

  def initialize(params = {})
    @current_position = params.fetch(:starting_position, [0,0])
    @directions = params.fetch(:directions, "")
    @locations_delivered_to = Set.new { @current_position }
    @new_locations = 0
    @existing_locations = 0
    @total_deliveries = 0
  end

  def deliver_next_present(direction)
    @current_position[0] = @current_position[0] + 1 if direction == "^"
    @current_position[0] = @current_position[0] - 1 if direction == "v"
    @current_position[1] = @current_position[1] + 1 if direction == ">"
    @current_position[1] = @current_position[1] - 1 if direction == "<"
    
    @new_locations += 1 unless @locations_delivered_to.include?(@current_position)
    @existing_locations += 1 if @locations_delivered_to.include?(@current_position)
    @total_deliveries += 1

    @locations_delivered_to << @current_position.clone
  end

  def deliver_all_presents
    @directions.each_char { |direction| deliver_next_present(direction) }

    puts "Total deliveries #{@total_deliveries} \tNew #{@new_locations} \tExisting #{@existing_locations}"
  end

  def deliveries
    @locations_delivered_to
  end

end