# frozen_string_literal: true

REGEXP = %r{\A\w+ can fly (?<speed>\d+) km/s for (?<fly>\d+) seconds, but then must rest for (?<rest>\d+) seconds.\z}

reindeer = ARGF.readlines(chomp: true).map do |line|
  line.match(REGEXP) do |match_data|
    {
      speed: match_data[:speed].to_i,
      fly: match_data[:fly].to_i,
      cycle_length: match_data[:fly].to_i + match_data[:rest].to_i,
      position: 0,
      score: 0
    }
  end
end

seconds = 2503

1.upto(seconds) do |second|
  reindeer.each do |data|
    data[:position] += data[:speed] if (1..data[:fly]).cover?(second % data[:cycle_length])
  end

  leading_pos = reindeer.map { |r| r[:position] }.max

  reindeer.each do |data|
    next unless data[:position] == leading_pos

    data[:score] += 1
  end
end

part_1 = reindeer.map { |r| r[:position] }.max
puts "Part 1: #{part_1}"

part_2 = reindeer.map { |r| r[:score] }.max
puts "Part 2: #{part_2}"
