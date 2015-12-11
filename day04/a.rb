# let's try a brute force method... 
# start at 1 and count up until with hit an MD5 hash that starts with '00000'

require 'digest'

md5 = Digest::MD5.new

# prime the pump
i = 1
secret_key = 'iwrupvqb'

md5 << "#{secret_key}#{i}"
puts "#{md5.hexdigest}\t#{secret_key}#{i}"
while (md5.hexdigest[0,5] != '00000') do
  i = i + 1
  md5 << "#{secret_key}#{i}"
  puts "#{md5.hexdigest}\t#{secret_key}#{i}\t#{md5.hexdigest[0,5]}"
end

puts i