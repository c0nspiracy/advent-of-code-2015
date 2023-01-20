# frozen_string_literal: true

def requirement_1(password)
  password.bytes.chunk_while { |i, j| j - i == 1 }.any? { |chunk| chunk.size == 3 }
end

def requirement_2(password)
  !password.match?(/[iol]/)
end

def requirement_3(password)
  first_match = password.match(/([a-z])\1/)
  return false unless first_match

  second_match = password.match(/([a-z])\1/, first_match.offset(0).last)
  return false unless second_match

  first_match[1] != second_match[1]
end

def valid_password?(password)
  requirement_2(password) && requirement_3(password) && requirement_1(password)
end

def find_next_password(password)
  password.next!

  loop do
    break if valid_password?(password)

    password.next!
    index = password.index(/[iol]./)
    next unless index

    password[index] = password[index].next
    pad_length = 7 - index
    password[index + 1, pad_length] = "a" * pad_length
  end

  password
end

input = ARGF.read.chomp

part_1 = find_next_password(input)
puts "Part 1: #{part_1}"

part_2 = find_next_password(part_1)
puts "Part 2: #{part_2}"
