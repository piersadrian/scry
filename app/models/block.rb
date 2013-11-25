# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Block < ActiveRecord::Base
  has_many :card_sets
  has_many :cards, through: :card_sets
end
