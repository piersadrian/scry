# == Schema Information
#
# Table name: card_sets
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  code         :string(255)
#  block_id     :integer
#  release_date :datetime
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#

class CardSet < ActiveRecord::Base

  STANDARD_CODES = %W(DGM GTC RTR THS M14)

  belongs_to :block
  has_many :editions
  has_many :cards, through: :editions do

    # The "rarity" scopes on Card use an `includes(:editions)` on the query
    # to include the Editions table, but coming from a CardSet the Editions
    # table is already included. So we override the Card scopes with these
    # association extensions instead. It saves a (potentially) big query.
    %W(common uncommon rare mythic_rare special basic_land).each do |meth|
      name = meth.titleize
      define_method meth, -> { where(editions: {rarity: name}) }
    end

  end

  scope :standard, -> { where(code: STANDARD_CODES) }
  scope :modern,   -> { where('release_date >= ?', find_by_code("8ED").release_date) }
end
