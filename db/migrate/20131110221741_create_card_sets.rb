class CreateCardSets < ActiveRecord::Migration
  def change
    create_table :card_sets do |t|
      t.string :name
      t.string :code
      t.integer :block_id, index: true
      t.datetime :release_date
      t.text :description

      t.timestamps
    end
  end
end
