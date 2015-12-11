# let's try a brute force method... 
# start at 1 and count up until with hit an MD5 hash that starts with '00000'
require 'set'
require 'digest'

md5 = Digest::MD5.new

# prime the pump
i = 1
secret_key = 'iwrupvqb'

while (md5.hexdigest("#{secret_key}#{i}")[0,5] != '00000') do
  i = i + 1
  puts "#{md5.hexdigest("#{secret_key}#{i}")}\t#{secret_key}#{i}\t#{md5.hexdigest("#{secret_key}#{i}")[0,5]}"
end

puts i