require_relative 'setup'



sleep_data = Setup.parsed_data
sleep_data.sort_by! { |entry| [entry.day, entry.hour, entry.minute] }
sleep_data.each { |entry| puts entry.raw }


guards = {}
last_guard = nil
last_entry = nil
sleep_data.map! do |entry| # this is premised on the first entry having a guard
  # assign the last guard to the log entry if the entry doesn't have a guard
  # entry.guard = last_guard unless entry.guard               <-|
  entry.guard = last_guard unless entry.guard > 0 # I think these two are the same <-|
  # this guard is to be carried over to the next log entry
  last_guard = entry.guard
  entry
end

guards = sleep_data.reduce({}) do |result, entry|
  result[entry.guard] ||= []
  result[entry.guard] << entry
  result
end

total_slept_by_guard = guards.map do |id, guard|
  # do magic to calculate duration of sleep and total all of them
  sleep_total = 0
  last_status = 'waking'
  start_time = nil
  sleep_total = guard.reduce(0) do |sleep_total, entry|
    if last_status == 'sleeping' && entry.status == 'waking'
      # calculate duration
      puts "Sleep total: #{sleep_total}"
      sleep_duration = (entry.time - start_time) / 60
      puts "Guard ##{entry.guard} slept for #{sleep_duration.to_i}"
      sleep_total += sleep_duration.to_i
      start_time = nil
    end
    if entry.status == 'sleeping'
      start_time = entry.time
    end
    last_status = entry.status
    sleep_total
  end
  [id, sleep_total]
end

total_slept_by_guard.each { |guard| puts "Guard ##{guard[0]} slept a total of #{guard[1]} minutes."}
sleepiest_guard = total_slept_by_guard.sort_by { |guard| guard[1] }.last

puts "Guard ##{sleepiest_guard[0]} slept the most with a total of #{sleepiest_guard[1]} minutes."
