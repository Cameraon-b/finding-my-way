module Health
  module_function

  def damage(player, amount)
    return 0 if player.god_mode

    player.hp = [player.hp - amount, 0].max
    amount
  end

  def heal(player, amount)
    before = player.hp
    player.hp = [player.hp + amount, player.max_hp].min
    player.hp - before
  end

  def dead?(player) = player.hp <= 0

  def bar(hp, max, width = 20)
    filled = (hp.to_f / max * width).round.clamp(0, width)
    "[#{'#' * filled}#{'-' * (width - filled)}] #{hp}/#{max}"
  end
end
