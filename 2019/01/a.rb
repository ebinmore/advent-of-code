def read_data
  modules = []
  File.open('./data').each_line do |mass|
    modules << mass.to_i
  end
  modules
end

def calculate_fuel(mass)
  Math.floor(mass / 3) - 2
end

modules = read_data
total_fuel = modules.each { |module_mass| calculate_fuel(module_mass) }

puts "The total fuel required is #{total_fuel}"
