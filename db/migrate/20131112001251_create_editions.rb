class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string :rarity
      t.text :flavor
      t.integer :set_number
      t.string :artist
      t.string :image_url

      t.belongs_to :card_set
      t.belongs_to :card

      t.timestamps
    end
  end
end
