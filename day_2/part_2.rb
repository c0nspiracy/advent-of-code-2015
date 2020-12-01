# frozen_string_literal: true

presents = File.readlines("input.txt", chomp: true).map do |line|
  line.split("x").map(&:to_i)
end

ribbon_length = presents.sum do |dimensions|
  smallest_perimeter = 2 * dimensions.min(2).sum
  volume = dimensions.inject(:*)

  smallest_perimeter + volume
end

puts ribbon_length
