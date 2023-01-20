# frozen_string_literal: true

aunts_sue = ARGF.readlines(chomp: true).each_with_object({}) do |line, memo|
  sue, data_string = line.split(": ", 2)
  data = data_string.split(", ").each_with_object({}) do |pair, data_memo|
    key, value = pair.split(": ")
    data_memo[key.to_sym] = value.to_i
  end
  sue_n = sue.scan(/\d+/).first.to_i
  memo[sue_n] = data
end

sample = {
  children: 3,
  cats: 7,
  samoyeds: 2,
  pomeranians: 3,
  akitas: 0,
  vizslas: 0,
  goldfish: 5,
  trees: 3,
  cars: 2,
  perfumes: 1
}

part_1 = aunts_sue.keys.find do |aunt|
  sample.all? do |key, value|
    next true unless aunts_sue[aunt].include?(key)

    aunts_sue[aunt][key] == value
  end
end

puts "Part 1: #{part_1}"

part_2 = aunts_sue.keys.find do |aunt|
  sample.all? do |key, value|
    next true unless aunts_sue[aunt].include?(key)

    case key
    when :cats, :trees
      aunts_sue[aunt][key] > value
    when :pomeranians, :goldfish
      aunts_sue[aunt][key] < value
    else
      aunts_sue[aunt][key] == value
    end
  end
end

puts "Part 2: #{part_2}"
