# frozen_string_literal: true

require "yaml"
require_relative "./actor"

Item = Struct.new(:name, :cost, :damage, :armor, keyword_init: true)

input = ARGF.readlines(chomp: true)
items = YAML.load_file("items").transform_values! do |group|
  group.map { |attrs| Item.new(attrs) }
end

boss_hp, boss_damage, boss_armor = input.map { |line| line.scan(/\d+$/).first.to_i }
no_rings = Item.new({ name: "No Rings", cost: 0, damage: 0, armor: 0 })
rings = items[:rings] + items[:rings].combination(2).to_a + [[no_rings]]
purchases = items[:weapons].product(items[:armor], rings).sort_by { |a| a.flatten.sum(&:cost) }

purchases.each do |weapon, armor, (ring_1, ring_2)|
  player = Actor.new(100)
  player.add_item(weapon)
  player.add_item(armor)
  player.add_item(ring_1) if ring_1
  player.add_item(ring_2) if ring_2

  boss = Actor.new(boss_hp, boss_damage, boss_armor)

  attacker = player
  defender = boss

  loop do
    attack = attacker.damage - defender.armor
    defender.attacked_by(attacker)
    break if defender.hp <= 0

    attacker, defender = defender, attacker
  end

  if boss.hp <= 0
    puts "Part 1: #{player.gold_spent}"
    break
  end
end

purchases.reverse_each do |weapon, armor, (ring_1, ring_2)|
  player = Actor.new(100)
  player.add_item(weapon)
  player.add_item(armor)
  player.add_item(ring_1) if ring_1
  player.add_item(ring_2) if ring_2

  boss = Actor.new(boss_hp, boss_damage, boss_armor)

  attacker = player
  defender = boss

  loop do
    attack = attacker.damage - defender.armor
    defender.attacked_by(attacker)
    break if defender.hp <= 0

    attacker, defender = defender, attacker
  end

  if boss.hp > 0
    puts "Part 2: #{player.gold_spent}"
    break
  end
end
