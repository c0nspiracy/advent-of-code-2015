# frozen_string_literal: true

input = ARGF.read.chomp

x = [0, 0]
y = [0, 0]
presents = Hash.new { |h, k| h[k] = 0 }

santas = [0, 1].cycle
input.chars.each do |char|
  i = santas.next
  presents[[y[i], x[i]]] += 1

  case char
  when "^" then y[i] -= 1
  when "v" then y[i] += 1
  when "<" then x[i] -= 1
  when ">" then x[i] += 1
  end
end

puts presents.keys.size
