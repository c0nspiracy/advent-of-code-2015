# frozen_string_literal: true

target = 29_000_000

def presents(house)
  house.downto(1).select { |n| house % n == 0 }.sum { |n| n * 10 }
end

binding.irb
