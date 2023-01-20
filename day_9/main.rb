# frozen_string_literal: true

input = ARGF.readlines(chomp: true)
distances = Hash.new { |h, k| h[k] = {} }

input.each do |line|
  origin, destination, distance = line.match(/(\w+) to (\w+) = (\d+)/).captures

  distances[origin][destination] = distance.to_i
  distances[destination][origin] = distance.to_i
end

routes = distances.keys.permutation.map do |route|
  route.each_cons(2).sum { |origin, destination| distances[origin][destination] }
end

puts "Part 1: #{routes.min}"
puts "Part 2: #{routes.max}"
