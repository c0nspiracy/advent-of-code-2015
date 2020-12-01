# frozen_string_literal: true

input = File.read("input.txt").chars
floor = 0

input.each.with_index(1) do |char, position|
  floor += (char == "(" ? 1 : -1)

  if floor == -1
    puts position
    break
  end
end
