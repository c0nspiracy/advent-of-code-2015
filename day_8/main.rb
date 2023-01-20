# frozen_string_literal: true

input = ARGF.readlines(chomp: true)

part_1 = input.sum { |line| line.length - line.undump.length }
puts "Part 1: #{part_1}"

part_2 = input.sum { |line| line.dump.length - line.length }
puts "Part 2: #{part_2}"
