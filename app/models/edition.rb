# == Schema Information
#
# Table name: editions
#
#  id          :integer          not null, primary key
#  rarity      :string(255)
#  flavor      :string(255)
#  set_number  :integer
#  artist      :string(255)
#  image_url   :string(255)
#  card_set_id :integer
#  card_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Edition < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_set
end
