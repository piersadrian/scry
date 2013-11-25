class RemoveColors < ActiveRecord::Migration
  def change
    drop_table(:colors)
    drop_table(:card_colors)
  end
end
