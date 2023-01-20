# frozen_string_literal: true

happiness = Hash.new { |h, k| h[k] = {} }

input = ARGF.readlines(chomp: true)

input.each do |line|
  match_data = line.match(/\A(?<name>\w+) would (?<sign>gain|lose) (?<units>\d+) happiness units by sitting next to (?<neighbour>\w+).\z/)

  units = match_data[:units].to_i
  units *= -1 if match_data[:sign] == "lose"
  happiness[match_data[:name]][match_data[:neighbour]] = units
end

def factorial(n)
  (1..n).inject(:*) || 1
end

def optimal_change_in_happiness(happiness)
  res = happiness.keys.flat_map do |key|
    (happiness.keys - [key]).permutation.map do |perm|
      perm = [key, *perm, key]
      perm.each_cons(2).sum { |a, b| happiness[a][b] + happiness[b][a] }
    end
  end
  n = happiness.keys.size
  puts "#{n}! = #{factorial(n)}"
  puts "#{n - 1}! = #{factorial(n - 1)}"
  puts res.size
  res.max
  # happiness.keys.permutation.filter_map do |perm|
  #   perm << perm[0]
  #   perm.each_cons(2).sum { |a, b| happiness[a][b] + happiness[b][a] }
  # end.max
end

puts optimal_change_in_happiness(happiness)

happiness.each_key { |guest| happiness[guest]["Rob"] = 0 }
happiness["Rob"] = Hash.new { |h, k| h[k] = 0 }

puts optimal_change_in_happiness(happiness)
