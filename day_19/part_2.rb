# frozen_string_literal: true

require "set"

def generation(mappings, molecule)
  new_molecules = Set.new
  mappings.each do |find, replacement|
    idxs = []
    offset = 0

    loop do
      break if offset >= molecule.length

      idx = molecule.index(find, offset)
      break if idx.nil?

      idxs << idx
      offset = idx + 1
    end

    idxs.each do |idx|
      new_molecule = molecule.dup
      new_molecule[idx, find.length] = replacement
      new_molecules << new_molecule
    end
  end

  new_molecules
end

*mapping_strings, _, target_molecule = ARGF.readlines(chomp: true)

mappings = mapping_strings.map { |string| string.split(" => ").reverse }
  .group_by(&:first)
  .transform_values { |a| a.map(&:last).last }
  .sort_by { |k, v| v.length + k.length }
  .reverse
  .to_h
elements = mappings.values.flatten.uniq - ["e"]

molecules = { target_molecule => 0 }
variant = target_molecule
#target_molecule = "e"

def get_variants(v, f, t)
  o = []
  v.scan(f) { o << Regexp.last_match.offset(0)[0] }
  o.each do |os|
    yield v[0, os] + t + v[(os + f.length)..]
  end
end

steps = 0
loop do
  break if variant == "e"
  break if steps > 10000
  puts variant if steps % 1000 == 0

  mappings.each do |from, to|
    get_variants(variant, from, to) do |v|
      variant = v
      steps += 1
      break
    end
  end
end

__END__
s = 0
loop do
  puts "Step #{s}, molecules = #{molecules.count}"
  new_molecules = Set.new
  molecules.select { |_, steps| steps == s }.each_key do |m|
    generation(mappings, m).each do |new_m|
      if molecules.key?(new_m)
        if molecules[new_m] > s
          new_molecules << new_m
        end
      else
        new_molecules << new_m
      end
    end
  end
  s += 1
  #puts new_molecules
  new_molecules.each { |m| molecules[m] = s }

  break if molecules.key?(target_molecule)
end

puts molecules[target_molecule]
