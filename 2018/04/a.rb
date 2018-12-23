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

guards = sleep_data.reduce({}) do |result, entry|
  result[entry.guard] ||= []
  result[entry.guard] << entry
  result
end

guards = guards.each do |id, log_entries|
  puts "Guard ##{id}"
  guard = Guard.new(log_entries)
  puts guard
  puts "Slept a total of #{guard.total_slept} minutes."
  puts "Most frequent minute slept: #{guard.most_frequently_slept_minute}"
end
