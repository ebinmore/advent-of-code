require 'optparse'
require 'byebug'
require 'pp'

debug = false
use_test_data = false
OptionParser.new do |opt|
  opt.on('-d', '--debug', 'run with debugging output') { |o| debug = true }
  opt.on('-t', '--test', 'use testing data') { |o| use_test_data = true }
end.parse!

data = {}
data[:rules], data[:orders] = if use_test_data
  rules_heredoc = <<~HEREDOC
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
  HEREDOC

  orders_heredoc = <<~HEREDOC
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
  HEREDOC
  
  [rules_heredoc.split("\n"), orders_heredoc.split("\n")]
else
  filename = 'rules.txt'
  rules_data = File.readlines(filename, chomp: true)

  filename = 'orders.txt'
  orders_data = File.readlines(filename, chomp: true)

  [rules_data, orders_data]
end

puts "DATA:"
pp data

def massage_data(data)
  return [
    data[:rules].map { |rule| rule.split("|").map(&:to_i) }.reduce({}) do |memo, rule|
      memo[rule[0]] = [] unless memo.key?(rule[0])
      memo[rule[0]] << rule[1]
      memo
    end,
    data[:orders].map { |order| { pages: order.split(",").map(&:to_i) } }
  ]
end

rules, orders = massage_data(data)

# validate orders
orders.each do |order|
  puts "order:"
  pp order
  order[:page_valid] = []
  order[:pages].each.with_index do |page, index|
    # must come before these pages
    come_before = rules[page] || []
    valid_before = index == 0 ? [] : (order[:pages][0..index-1] & come_before)

    # must come after these pages
    come_after = rules.select { |key, value| value.include?(page) }.keys || []
    valid_after = index == order[:pages].length ? []: (order[:pages][index+1..order[:pages].length] & come_after)

    order[:page_valid] << valid_before.empty? && valid_after.empty?
  end
  puts "valid? #{order[:page_valid].all?(true)}"
  puts

  if order[:page_valid].all?
    # find the middle page
    middle_index = order[:pages].length / 2
    middle_element = order[:pages][middle_index]

    order[:middle] = {
      index: middle_index,
      element: middle_element
    }
  end
end

puts "orders:"
pp orders
puts 

middle_sum = orders.reduce(0) do |sum, order|
  sum += order[:page_valid].all? ? order[:middle][:element] : 0
  sum
end

puts "middle sum: #{middle_sum}"
