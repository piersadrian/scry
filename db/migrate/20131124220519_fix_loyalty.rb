class FixLoyalty < ActiveRecord::Migration
  def change
    change_column_default(:cards, :loyalty, nil)

    Card.find_each do |card|
      if card.loyalty == 0 && card.card_type.match(/planeswalker/i).nil?
        card.update_attributes(loyalty: nil)
      end
    end
  end
end
