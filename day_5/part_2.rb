# frozen_string_literal: true

input = ARGF.readlines(chomp: true)

answer = input.count do |line|
  line.match?(/(..).*\1/) &&
    line.match?(/(.).\1/)
end

puts answer
