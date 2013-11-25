class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :mana_cost
      t.integer :converted_cost, index: true, default: 0
      t.integer :power, index: true, default: 0
      t.integer :toughness, index: true, default: 0
      t.integer :loyalty, index: true, default: 0

      t.string :card_type
      t.string :subtype
      t.text :text

      t.string :rarity
      t.string :mv_id
      t.integer :set_id, index: true
      t.integer :set_number
      t.text :flavor
      t.string :artist

      t.string :image_url

      t.timestamps
    end
  end
end
