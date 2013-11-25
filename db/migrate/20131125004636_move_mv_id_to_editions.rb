class MoveMvIdToEditions < ActiveRecord::Migration
  def change
    add_column(:editions, :mv_id, :string)
    remove_column(:cards, :mv_id)

    Edition.reset_column_information

    Edition.find_each do |edition|
      edition.update_attributes(mv_id: edition.image_url.match(/\d+/).try(:first))
    end
  end
end
