# == Schema Information
#
# Table name: editions
#
#  id          :integer          not null, primary key
#  rarity      :string(255)
#  flavor      :text
#  set_number  :integer
#  artist      :string(255)
#  image_url   :string(255)
#  card_set_id :integer
#  card_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  mv_id       :string(255)
#

class Edition < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_set

  def image_url
    "http://mtgimage.com/multiverseid/#{ mv_id }.jpg"
  end

  def image_crop_url
    "http://mtgimage.com/multiverseid/#{ mv_id }-crop.jpg"
  end
end
