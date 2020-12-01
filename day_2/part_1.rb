# frozen_string_literal: true

presents = File.readlines("input.txt", chomp: true).map do |line|
  line.split("x").map(&:to_i)
end

paper_area = presents.sum do |dimensions|
  areas = dimensions.combination(2).map { |pair| pair.inject(:*) }
  surface_area = 2 * areas.sum
  area_of_smallest_side = areas.min

  surface_area + area_of_smallest_side
end

puts paper_area
