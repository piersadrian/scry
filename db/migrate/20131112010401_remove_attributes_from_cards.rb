class RemoveAttributesFromCards < ActiveRecord::Migration
  def change
    change_table :cards do |t|
      t.remove :set_id
      t.remove *(Edition.attribute_names - ["id", "created_at", "updated_at", "card_id", "card_set_id"])
    end
  end
end
