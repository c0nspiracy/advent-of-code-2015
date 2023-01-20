# frozen_string_literal: true

require "set"

def generation(mappings, molecule)
  new_molecules = Set.new
  mappings.each do |find, replacements|
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
      replacements.each do |replacement|
        new_molecule = molecule.dup
        new_molecule[idx, find.length] = replacement
        new_molecules << new_molecule
      end
    end
  end

  new_molecules
end

*mapping_strings, _, target_molecule = ARGF.readlines(chomp: true)

mappings = mapping_strings.map { |string| string.split(" => ").reverse }
                          .group_by(&:first)
                          .transform_values { |a| a.map(&:last) }

molecules = { target_molecule => 0 }
target_molecule = "e"

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
