# == Schema Information
#
# Table name: cards
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  mana_cost      :string(255)
#  converted_cost :integer          default(0)
#  power          :integer          default(0)
#  toughness      :integer          default(0)
#  loyalty        :integer          default(0)
#  card_type      :string(255)
#  subtype        :string(255)
#  text           :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Card < ActiveRecord::Base
  has_many :editions
  has_many :card_sets, through: :editions
  has_many :blocks, through: :card_sets

  validates :name, uniqueness: true

  %W(name text card_type subtype).each do |attr|
    scope "with_#{ attr }", ->(q) { where("LOWER(#{ attr }) LIKE LOWER(?)", "%#{ q }%") }
  end

  %W(common uncommon rare mythic_rare special basic_land).each do |meth|
    name = meth.titleize
    scope meth, -> { includes(:editions).where(editions: {rarity: name}) }
  end

  %W(blue green black red white).each do |color|
    letter = color == "blue" ? "U" : color.first.upcase
    scope color, -> { where("mana_cost LIKE ?", "%#{ letter }%") }
  end

  scope :standard, -> {
    includes(:editions).where(editions: {
      card_set_id: CardSet.standard.pluck(:id)
    })
  }

  scope :modern, -> {
    includes(:editions).where(editions: {
      card_set_id: CardSet.modern.pluck(:id)
    })
  }

  %W(names texts card_types subtypes).each do |attr|
    scope attr, -> { pluck(:id, attr.singularize) }
  end

  %W(creatures sorceries lands planeswalkers
    artifacts enchantments instants).each do |type|
    scope type, -> { where("LOWER(card_type) LIKE LOWER(?)", "%#{ type.singularize }%") }
  end

  def inspect
    out = ""

    out << "==============================================\n"
    out << "#{ id }\n"

    color_str = ""

    if mana_cost
      color_chars = mana_cost.gsub(/[0-9{}]/, '').chars.uniq

      if color_chars.count > 1
        color_str = "\e[43m\e[1;37m"
      else
        color_str = case color_chars.first
          when /W/
            "\e[47m\e[1m"
          when /G/
            "\e[42m\e[1;37m"
          when /R/
            "\e[41m\e[1;37m"
          when /U/
            "\e[44m\e[1;37m"
          when /B/
            "\e[47m\e[30m"
          else
            "\e[37m"
        end
      end
    end

    out << sprintf("#{ color_str }%-28s%18s\e[0m\n", name, "#{ mana_cost }")
    out << sprintf("#{ color_str }%-46s\e[0m\n\n", [card_type, subtype].compact.join(" — "))

    in_paras  = text.split("\n")
    out_paras = []

    in_paras.each do |para|
      lines = []

      para.split(/ /).each do |tkn|
        if lines.last && (lines.last.length + tkn.length < 46)
          last_line = lines.pop
          last_line << " "
          last_line << tkn
          lines << last_line
        else
          lines << tkn
        end
      end

      out_paras << lines.join("\n")
    end

    out << out_paras.join("\n\n")

    if loyalty? || power? || toughness?
      stats  = " #{ loyalty.presence || [power, toughness].compact.join("/") } "
      offset = 46 - stats.length
      out << sprintf("\n%#{ offset }s#{ color_str }%0s\e[0m", "", stats)
    end

    out << "\n\n"
  end
  alias_method :to_s, :inspect
end
