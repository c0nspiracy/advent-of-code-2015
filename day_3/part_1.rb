# frozen_string_literal: true

input = ARGF.read.chomp

x = 0
y = 0
presents = Hash.new { |h, k| h[k] = 0 }

input.chars.each do |char|
  presents[[y, x]] += 1

  case char
  when "^" then y -= 1
  when "v" then y += 1
  when "<" then x -= 1
  when ">" then x += 1
  end
end

puts presents.keys.size
