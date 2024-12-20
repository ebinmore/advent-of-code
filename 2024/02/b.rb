require 'optparse'
require 'ostruct'
require 'byebug'
require 'pp'

debug = false
use_test_data = false
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| debug = true }
  opt.on('-t', '--test', 'use testing data') { |o| use_test_data = true }
end.parse!

data = if use_test_data
  # reports = [[levels ...], ...]
  [
    [7, 6, 4, 2, 1],
    [1, 2, 7, 8, 9],
    [9, 7, 6, 2, 1],
    [1, 3, 2, 4, 5],
    [8, 6, 4, 4, 1],
    [1, 3, 6, 7, 9],
  ]
else
  reports = []
  filename = 'input.csv'
  File.foreach(filename, chomp: true) do |line|
    reports << line.split(/\s+/).map(&:to_i)
  end
  reports
end

puts "reports: #{data.count}"
pp data if debug

# analyze the report by computing the difference as 
# (n+1 - n)
def compute_report_differences(report)
  differences = []
  report.each.with_index do |level, level_index| 
    next if level_index == report.count - 1
    difference = report[level_index + 1] - level
    differences << difference
  end
  differences
end

# determine if the report is safe
# all differences are increasing or decreasing
# adjacent levels must differ by at least 1, at most 3
def report_safe?(differences)
  (differences.all? { |x| x < 0} || differences.all? { |x| x > 0}) &&
  differences.all? { |x| x.abs >= 1 } && 
  differences.all? { |x| x.abs <= 3 }
end

# analyze the reports by finding the differences between levels
analyses = {}
data.each.with_index do |report, report_index|
  differences = compute_report_differences(report)
  analyses[report_index] = { 
    findings: [
      { data: report, differences: differences, safe: report_safe?(differences) }
    ] 
  }
end

safe_reports = analyses.select do |report_index, analysis|
  analysis[:findings].any? { |finding| finding[:safe] }
end

unsafe_reports = analyses.reject do |report_index, analysis|
  analysis[:findings].any? { |finding| finding[:safe] }
end


unsafe_reports.each do |report_index, analysis|
  finding = analysis[:findings].first
  differences = finding[:differences]
  # count how many were increasing & decreasing
  finding[:size] = differences.length
  finding[:increasing] = differences.select { |x| x > 0 }.length
  finding[:decreasing] = differences.select { |x| x < 0 }.length
  # if increasing or decreasing is within 1 of the overall size, reprocess

  # count how many are under 1 or over 3
  finding[:zero] = differences.select { |x| x.abs == 0}.length
  finding[:four_or_more] = differences.select { |x| x.abs > 3}.length
  # if there's only one zero or one over 3, reprocess
  
  finding[:dampener] = {
    direction: {
      increasing: (finding[:size] - finding[:increasing] == 1),
      decreasing: (finding[:size] - finding[:decreasing] == 1),
      already_good: (finding[:size] - finding[:increasing] - finding[:decreasing] == 0)
    },
    bounds: { 
      zero: (finding[:zero] == 1 && finding[:four_or_more] == 0),
      four_or_more: (finding[:four_or_more] == 1 && finding[:zero] == 0),
      already_good: (finding[:zero] == 0 && finding[:four_or_more] == 0)
    }
  }
end

# apply Problem Dampener
unsafe_reports.each do |report_index, analysis|
  preliminary = analysis[:findings].first

  # one decreasing difference
  if preliminary[:dampener][:direction][:increasing]
    # candidate to remove one (ie the first) decreasing dimension
    index = preliminary[:differences].index { |diff| diff < 1 }
    puts "decreasing index: #{index}"

    # remove the n data element
    n_removed = ([] + preliminary[:data])
    n_removed.delete_at(index)
    analyzed_n_removed = compute_report_differences(n_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n_removed, safe: report_safe?(analyzed_n_removed) }

    # remove the n+1 data element
    n1_removed = ([] + preliminary[:data])
    n1_removed.delete_at(index + 1)
    analyzed_n1_removed = compute_report_differences(n1_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n1_removed, safe: report_safe?(analyzed_n1_removed) }
  end

  # one increasing difference
  if preliminary[:dampener][:direction][:decreasing]
    # candidate to remove one (ie the first) increasing dimension
    index = preliminary[:differences].index { |diff| diff > -1 }
    puts "increasing index: #{index}"

    # remove the n data element
    n_removed = ([] + preliminary[:data])
    n_removed.delete_at(index)
    analyzed_n_removed = compute_report_differences(n_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n_removed, safe: report_safe?(analyzed_n_removed) }

    # remove the n+1 data element
    n1_removed = ([] + preliminary[:data])
    n1_removed.delete_at(index + 1)
    analyzed_n1_removed = compute_report_differences(n1_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n1_removed, safe: report_safe?(analyzed_n1_removed) }    
  end

  # one zero
  if preliminary[:dampener][:bounds][:zero]
    # candidate to remove one (ie the first) zero
    index = preliminary[:differences].index { |diff| diff == 0 }
    puts "zero index: #{index}"

    # remove the n data element
    n_removed = ([] + preliminary[:data])
    n_removed.delete_at(index)
    analyzed_n_removed = compute_report_differences(n_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n_removed, safe: report_safe?(analyzed_n_removed) }

    # remove the n+1 data element
    n1_removed = ([] + preliminary[:data])
    n1_removed.delete_at(index + 1)
    analyzed_n1_removed = compute_report_differences(n1_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n1_removed, safe: report_safe?(analyzed_n1_removed) }    
  end

  # one four+
  if preliminary[:dampener][:bounds][:four_or_more]
    # candidate to remove one (ie the first) value greater than 3
    index = preliminary[:differences].index { |diff| diff.abs > 3 }
    puts "four+ index: #{index}"

    byebug if index.nil?
    # remove the n data element
    n_removed = ([] + preliminary[:data])
    n_removed.delete_at(index)
    analyzed_n_removed = compute_report_differences(n_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n_removed, safe: report_safe?(analyzed_n_removed) }

    # remove the n+1 data element
    n1_removed = ([] + preliminary[:data])
    n1_removed.delete_at(index + 1)
    analyzed_n1_removed = compute_report_differences(n1_removed)
    analysis[:findings] << { data: n_removed, differences: analyzed_n1_removed, safe: report_safe?(analyzed_n1_removed) }    
  end
end

pp unsafe_reports

puts "# of SAFE reports: #{safe_reports.length}"
puts "# of preliminary UNSAFE reports: #{unsafe_reports.length}"

dampener_safe = unsafe_reports.select do |index, analysis|
  analysis[:findings].any? { |finding| finding[:safe] }
end

puts "# of dampener SAFE reports: #{dampener_safe.length}"
puts "TOTAL # of SAFE reports: #{safe_reports.length + dampener_safe.length}"
