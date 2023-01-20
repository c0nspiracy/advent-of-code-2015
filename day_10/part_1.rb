# frozen_string_literal: true

input = ARGF.read.chomp.chars.map(&:to_i)

40.times do
  input = input.chunk(&:itself).flat_map { |c, a| [a.size, c] }
end

puts "Part 1: #{input.size}"

10.times do
  input = input.chunk(&:itself).flat_map { |c, a| [a.size, c] }
end

puts "Part 2: #{input.size}"
