# frozen_string_literal: true

lights = Hash.new { |h, k| h[k] = 0 }

input = ARGF.readlines(chomp: true).map do |line|
  [line.match(/^(\D+) /)[1], *line.scan(/\d+/).map(&:to_i)]
end

input.each do |op, y1, x1, y2, x2|
  y1.upto(y2) do |y|
    x1.upto(x2) do |x|
      case op
      when "turn on"
        lights[[y, x]] += 1
      when "turn off"
        lights[[y, x]] -= 1 unless lights[[y, x]].zero?
      when "toggle"
        lights[[y, x]] += 2
      end
    end
  end
end

puts lights.values.sum
