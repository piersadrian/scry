class CreateCardColors < ActiveRecord::Migration
  def change
    create_table :card_colors do |t|
      t.integer :card_id
      t.integer :color_id

      t.timestamps
    end

    add_index(:card_colors, [:card_id, :color_id])
  end
end
