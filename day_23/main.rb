# frozen_string_literal: true

def run_program(instructions, registers = {})
  registers = { "a" => 0, "b" => 0 }.merge(registers)
  ip = 0

  loop do
    break if ip >= instructions.length

    offset = 1

    case instructions[ip]
    when /hlf ([ab])/
      registers[$1] /= 2
    when /tpl ([ab])/
      registers[$1] *= 3
    when /inc ([ab])/
      registers[$1] += 1
    when /jmp ([+-]\d+)/
      offset = $1.to_i
    when /jie ([ab]), ([+-]\d+)/
      offset = $2.to_i if registers[$1].even?
    when /jio ([ab]), ([+-]\d+)/
      offset = $2.to_i if registers[$1] == 1
    else
      raise "Invalid instruction #{instruction}"
    end

    ip += offset
  end

  registers
end

instructions = ARGF.readlines(chomp: true)

registers = run_program(instructions)
puts "Part 1: #{registers['b']}"

registers = run_program(instructions, { "a" => 1 })
puts "Part 2: #{registers['b']}"
