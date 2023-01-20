# frozen_string_literal: true

require "json"

def sum_hash(hash)
  hash.value?("red") ? 0 : sum_object(hash.values)
end

def sum_object(object)
  object.sum do |value|
    case value
    when Hash then sum_hash(value)
    when Array then sum_object(value)
    when Integer then value
    else 0
    end
  end
end

input = ARGF.read.chomp
doc = JSON.parse(input)

puts "Part 1: #{input.scan(/-?\d+/).sum(&:to_i)}"
puts "Part 2: #{sum_object([doc])}"
