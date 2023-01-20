# frozen_string_literal: true

require "digest"

input = ARGF.read.chomp

n = 1
loop do
  md5 = Digest::MD5.hexdigest(input + n.to_s)
  break if md5.start_with?("00000")

  n += 1
end

puts n
