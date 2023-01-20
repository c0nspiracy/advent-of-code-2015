# frozen_string_literal: true

class Actor
  def initialize(hp, damage = 0, armor = 0)
    @hp = hp
    @damage = damage
    @armor = armor
    @items = []
  end

  def hp
    [@hp, 0].max
  end

  def add_item(item)
    @items << item
  end

  def armor
    @armor + @items.sum(&:armor)
  end

  def damage
    @damage + @items.sum(&:damage)
  end

  def gold_spent
    @items.sum(&:cost)
  end

  def attacked_by(attacker)
    attack_power = [attacker.damage - armor, 1].max
    @hp -= attack_power
  end
end
