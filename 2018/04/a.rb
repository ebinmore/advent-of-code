require_relative 'setup'
require_relative 'guard'



sleep_data = Setup.parsed_data
sleep_data.sort_by! { |entry| [entry.year, entry.month, entry.day, entry.hour, entry.minute] }
sleep_data.each { |entry| puts entry.raw }


guards = {}
last_guard = nil
last_entry = nil
sleep_data = sleep_data.map do |entry| # this is premised on the first entry having a guard
  # assign the last guard to the log entry if the entry doesn't have a guard
  entry.guard = last_guard unless entry.guard > 0
  # this guard is to be carried over to the next log entry
  last_guard = entry.guard
  entry
end

logs_by_guard = sleep_data.reduce({}) do |result, entry|
  result[entry.guard] ||= []
  result[entry.guard] << entry
  result
end

guards = logs_by_guard.values.map { |logs| Guard.new(logs) }


guards.each do |guard|
  puts guard
  puts "Slept a total of #{guard.total_slept} minutes."
  puts "Most frequent minute slept: #{guard.most_frequently_slept_minute} - #{guard.occurrence_of_most_frequently_slept_minute}"
  puts
end

sleepiest_guard = guards.max { |a, b| a.total_slept <=> b.total_slept }

puts "---------------------------------------------------------------------------"
puts "The sleepiest guard is #{sleepiest_guard.id}."
puts "They slept a total of #{sleepiest_guard.total_slept} minutes!"
puts "The most frequent minute slept was #{sleepiest_guard.most_frequently_slept_minute}."
puts "---------------------------------------------------------------------------"
puts
puts "#{sleepiest_guard.id} x #{sleepiest_guard.most_frequently_slept_minute} = #{sleepiest_guard.most_frequently_slept_minute.to_i * sleepiest_guard.id.to_i}"

most_frequently_sleeping_guard = guards.max { |a, b| a.occurrence_of_most_frequently_slept_minute <=> b.occurrence_of_most_frequently_slept_minute }

puts "---------------------------------------------------------------------------"
puts "The guard most frequently asleep is #{most_frequently_sleeping_guard.id}."
puts "They slept a total of #{most_frequently_sleeping_guard.total_slept} minutes!"
puts "They were asleep #{most_frequently_sleeping_guard.occurrence_of_most_frequently_slept_minute} times at #{most_frequently_sleeping_guard.most_frequently_slept_minute} minute."
puts "---------------------------------------------------------------------------"
puts
puts "#{most_frequently_sleeping_guard.id} x #{most_frequently_sleeping_guard.most_frequently_slept_minute} = #{most_frequently_sleeping_guard.most_frequently_slept_minute.to_i * most_frequently_sleeping_guard.id.to_i}"

