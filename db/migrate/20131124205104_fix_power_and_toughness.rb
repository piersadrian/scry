class FixPowerAndToughness < ActiveRecord::Migration
  def change
    change_column_default(:cards, :power, nil)
    change_column_default(:cards, :toughness, nil)

    Card.find_each do |card|
      if card.power == 0 && card.toughness == 0 && card.card_type.match(/creature/i).nil?
        card.update_attributes(power: nil, toughness: nil)
      end
    end
  end
end
