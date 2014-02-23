module Import
  class Base
    attr_accessor :data
  end

  class MTGDB < Base
    class << self

      def import_cards!(card_set, path)
        @data = JSON.parse( File.read(path) )

        @data.each do |h|
          card = Card.find_or_initialize_by(name: h["name"])

          if card.new_record?
            card.assign_attributes({
              mana_cost: h["manaCost"],
              converted_cost: h["convertedManaCost"],
              power: h["power"],
              toughness: h["toughness"],
              toughness: h["toughness"],
              card_type: h["type"],
              subtype: h["subType"],
              text: h["description"]
            })
            card.save
          end

          card.editions.create({
            card_set: card_set,
            rarity: h["rarity"],
            flavor: h["flavor"],
            set_number: h["setNumber"],
            image_url: h["cardImage"],
            mv_id: h["id"]
          })
        end
      end
    end

  end
end
