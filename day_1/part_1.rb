# frozen_string_literal: true

input = File.read("input.txt").chars
puts input.count("(") - input.count(")")
