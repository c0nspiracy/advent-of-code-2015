# frozen_string_literal: true

class Combinations
  def initialize
    @combinations = []
  end

  def combinations(numbers, target, partial = [])
    sum = partial.sum
    @combinations << partial if sum == target
    return if sum >= target

    numbers.each_with_index do |number, i|
      remaining = numbers.drop(i + 1)
      combinations(remaining, target, partial + [number])
    end

    @combinations
  end
end

containers = ARGF.readlines(chomp: true).map(&:to_i)
combinations = Combinations.new.combinations(containers, 150)
puts "Part 1: #{combinations.size}"

min_containers = combinations.map(&:size).min
ways_to_use_containers = combinations.count { |combination| combination.size == min_containers }
puts "Part 2: #{ways_to_use_containers}"
