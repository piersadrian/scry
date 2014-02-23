class AddDefaultsToCardColumns < ActiveRecord::Migration
  def change
    change_column_default(:cards, :power, 0)
    change_column_default(:cards, :toughness, 0)
    change_column_default(:cards, :loyalty, 0)
  end
end
