# frozen_string_literal: true

require "set"

*mapping_strings, _, molecule = ARGF.readlines(chomp: true)

mappings = mapping_strings.map { |string| string.split(" => ") }
                          .group_by(&:first)
                          .transform_values { |a| a.map(&:last) }

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

puts new_molecules.count
