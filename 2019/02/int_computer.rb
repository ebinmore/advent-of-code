class IntComputer

  def initialize(program, alarm_code: nil)
    @initial_state = program.to_s.split(',').map(&:to_i)
    if alarm_code
      noun, verb = alarm_code[0..1].to_i, alarm_code[2..3].to_i
      @initial_state[1] = noun
      @initial_state[2] = verb
    end
  end

  def perform_operation
    # read the current address and determine the operation
    instruction = @memory[@instruction_pointer]
    case instruction
    when 1
      # grab the values from address @memory[@instruction_pointer+1] and @memory[@instruction_pointer+2]
      pos_a = @memory[@instruction_pointer + 1]
      pos_b = @memory[@instruction_pointer + 2]
      pos_c = @memory[@instruction_pointer + 3]

      a = @memory[pos_a]
      b = @memory[pos_b]
      # add them
      c = a + b
      # store them in address @memory[@instruction_pointer+3]
      @memory[pos_c] = c
      # increment @instruction_pointer = @instruction_pointer+4
      @instruction_pointer += 4
      # puts "adding pos #{pos_a} (#{a}) and pos #{pos_b} (#{b}) and storing in #{pos_c} (#{c})"
    when 2
      # grab the two values - @memory[@instruction_pointer+1] and @memory[@instruction_pointer+2]
      pos_a = @memory[@instruction_pointer + 1]
      pos_b = @memory[@instruction_pointer + 2]
      pos_c = @memory[@instruction_pointer + 3]

      a = @memory[pos_a]
      b = @memory[pos_b]
      # multiply them
      c = a * b
      # store them in address @memory[@instruction_pointer+3]
      @memory[pos_c] = c
      # increment @instruction_pointer = @instruction_pointer+4
      @instruction_pointer += 4
      # puts "multiplying pos #{pos_a} (#{a}) and pos #{pos_b} (#{b}) and storing in #{pos_c} (#{c})"
    when 99
      # stop
      puts 'terminating program'
      return false
    end

    # more to process
    true
  end

  def run_program
    puts "initial_state: #{@initial_state}"
    @memory = @initial_state
    @instruction_pointer = 0

    loop do
      # puts "memory: #{@memory.join(',')}"
      # puts "current address: #{@instruction_pointer}"
      # puts "performing operation: #{@memory[@instruction_pointer]}"
      break unless perform_operation
    end

    @memory
  end
end
