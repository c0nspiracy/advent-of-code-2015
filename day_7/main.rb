# frozen_string_literal: true

# Models a bitwise logic gate circuit
class Circuit
  OPS = {
    and: ->(a, b) { a & b },
    or: ->(a, b) { a | b },
    lshift: ->(a, b) { a << b },
    rshift: ->(a, b) { a >> b },
    not: ->(a) { ~a % 65_536 },
    assign: ->(a) { a }
  }.freeze

  def initialize(wires, signals)
    @starting_wires = wires
    @starting_signals = signals
    reset
  end

  def reset(signals = @starting_signals)
    @wires = @starting_wires.dup
    @signals = signals.dup
  end

  def run
    loop do
      break if complete?

      gates_with_all_inputs_receiving_signal.each do |target, (op, *args)|
        args.map! { |arg| arg.is_a?(String) ? @signals[arg] : arg }
        @signals[target] = OPS[op].call(*args)
        @wires.delete(target)
      end
    end

    @signals["a"]
  end

  private

  def complete?
    @wires.empty?
  end

  def gates_with_all_inputs_receiving_signal
    @wires.select do |_, instructions|
      instructions.grep(String).all? { |wire| @signals.key?(wire) }
    end
  end
end

input = ARGF.readlines(chomp: true)
signals = {}
wires = {}

TARGET = /-> (?<target>[a-z]+)\z/

input.each do |instruction|
  case instruction
  when /\A(?<signal>\d+) #{TARGET}/
    signals[Regexp.last_match[:target]] = Regexp.last_match[:signal].to_i
  when /\A(?<source_1>[a-z]+) (?<op>AND|OR) (?<source_2>[a-z]+) #{TARGET}/
    m = Regexp.last_match
    wires[m[:target]] = [m[:op].downcase.to_sym, m[:source_1], m[:source_2]]
  when /\A(?<value>\d+) (?<op>AND|OR) (?<source>[a-z]+) #{TARGET}/
    m = Regexp.last_match
    wires[m[:target]] = [m[:op].downcase.to_sym, m[:value].to_i, m[:source]]
  when /\A(?<source>[a-z]+) (?<op>.SHIFT) (?<value>\d+) #{TARGET}/
    m = Regexp.last_match
    wires[m[:target]] = [m[:op].downcase.to_sym, m[:source], m[:value].to_i]
  when /\ANOT ([a-z]+) -> ([a-z]+)\z/
    wires[Regexp.last_match(2)] = [:not, Regexp.last_match(1)]
  when /\A([a-z]+) -> ([a-z]+)\z/
    wires[Regexp.last_match(2)] = [:assign, Regexp.last_match(1)]
  else
    raise "Unhandled instruction #{instruction}"
  end
end

circuit = Circuit.new(wires, signals)
part_1 = circuit.run

signals["b"] = part_1
circuit.reset(signals)
part_2 = circuit.run

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
