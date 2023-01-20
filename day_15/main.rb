# frozen_string_literal: true

REGEXP = /\A
  (?<ingredient>\w+):\s
  capacity\s(?<capacity>-?\d+),\s
  durability\s(?<durability>-?\d+),\s
  flavor\s(?<flavor>-?\d+),\s
  texture\s(?<texture>-?\d+),\s
  calories\s(?<calories>-?\d+)
\z/x

class Cookie
  def initialize(ingredients)
    @ingredients = ingredients
  end

  def score(recipe)
    %i[capacity durability flavor texture].map do |property|
      sum = recipe.sum do |ingredient, teaspoons|
        teaspoons * @ingredients[ingredient][property]
      end

      sum.negative? ? 0 : sum
    end.reduce(:*)
  end

  def calories(recipe)
    recipe.sum do |ingredient, teaspoons|
      teaspoons * @ingredients[ingredient][:calories]
    end
  end

  def recipes(ingredients = @ingredients.keys, recipe = {})
    ingredients_remaining = ingredients - recipe.keys
    return recipe if ingredients_remaining.empty?

    next_ingredient = ingredients_remaining.pop

    recipe_total = recipe.values.sum
    max_teaspoons = 100 - recipe_total - ingredients_remaining.size
    min_teaspoons = ingredients_remaining.empty? ? max_teaspoons : 1

    (min_teaspoons..max_teaspoons).flat_map do |amount|
      recipes(ingredients_remaining, recipe.merge(next_ingredient => amount))
    end
  end
end

ingredients = ARGF.readlines(chomp: true).each_with_object({}) do |line, memo|
  line.match(REGEXP) do |match_data|
    named_captures = match_data.named_captures.transform_keys(&:to_sym)
    ingredient = named_captures.delete(:ingredient)

    memo[ingredient] = named_captures.transform_values(&:to_i)
  end
end

cookie = Cookie.new(ingredients)
recipes = cookie.recipes

part_1 = recipes.map { |recipe| cookie.score(recipe) }.max
puts "Part 1: #{part_1}"

part_2_recipes = recipes.select { |recipe| cookie.calories(recipe) == 500 }
part_2 = part_2_recipes.map { |recipe| cookie.score(recipe) }.max
puts "Part 2: #{part_2}"
