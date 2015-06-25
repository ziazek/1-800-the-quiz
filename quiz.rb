#!/usr/bin/env ruby

total = 0

File.readlines('/usr/share/dict/words').each do |line|
  puts line
  total += 1
end

puts total