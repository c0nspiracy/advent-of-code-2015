# frozen_string_literal: true

class GameOfLife
  DELTAS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  def initialize(state, part_2: false)
    @state = state
    @part_2 = part_2
    @neighbour_cache = {}

    if @part_2
      @state[0][0] = "#"
      @state[0][max_index] = "#"
      @state[max_index][0] = "#"
      @state[max_index][max_index] = "#"
    end
  end

  def next_generation
    new_state = Array.new(size) { Array.new(size, ".") }

    size.times do |y|
      size.times do |x|
        n_on = neighbours_on(y, x)
        next if n_on < 2 || n_on > 3

        cell = @state[y][x]
        new_state[y][x] = "#" if cell == "#" || (cell == "." && n_on == 3)
      end
    end

    if @part_2
      new_state[0][0] = "#"
      new_state[0][max_index] = "#"
      new_state[max_index][0] = "#"
      new_state[max_index][max_index] = "#"
    end

    @state = new_state
    nil
  end

  def lights_on
    @state.sum { |row| row.count("#") }
  end

  private

  def neighbours_on(y, x)
    neighbour_positions(y, x).count { |y, x| @state[y][x] == "#" }
  end

  def neighbour_positions(y, x)
    @neighbour_cache.fetch([y, x]) do
      neighbours = DELTAS.map { |dy, dx| [dy + y, dx + x] }
      positions = neighbours.select { |ny, nx| cell_range.cover?(ny) && cell_range.cover?(nx) }
      @neighbour_cache[[y, x]] = positions
    end
  end

  def cell_range
    @cell_range ||= (0..max_index)
  end

  def max_index
    @max_index ||= size - 1
  end

  def size
    @size ||= @state.size
  end
end

input = ARGF.readlines(chomp: true).map(&:chars)

game = GameOfLife.new(input)
100.times { game.next_generation }
puts "Part 1: #{game.lights_on}"

game = GameOfLife.new(input, part_2: true)
100.times { game.next_generation }
puts "Part 2: #{game.lights_on}"
