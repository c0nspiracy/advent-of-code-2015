# frozen_string_literal: true

input = ARGF.readlines(chomp: true)

answer = input.count do |line|
  line.count("aeiou") >= 3 &&
    line.match?(/(.)\1/) &&
    !line.match?(/ab|cd|pq|xy/)
end

puts answer
