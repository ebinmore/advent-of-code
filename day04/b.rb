# let's try a brute force method... 
# start at 346386 and count up until with hit an MD5 hash that starts with '000000'
require 'set'
require 'digest'

md5 = Digest::MD5.new

# prime the pump
i = 346386 # answer to part a... no values exist prior to this value that would qualify
secret_key = 'iwrupvqb'

while (md5.hexdigest("#{secret_key}#{i}")[0,6] != '000000') do i = i + 1 end
puts i