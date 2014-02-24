class CardsController < ApplicationController
  def show
    @card = if params[:id].to_i == 0
      Card.order(id: :desc).find_by_name( params[:id] )
    else
      Card.find_by_id( params[:id] )
    end

    @editions = Card.order(id: :desc)
                    .where(name: @card.name)
                    .includes(:card_set)
  end

  def search
    scope = Card.includes(:editions).limit(params[:num].presence || 5)

    @cards = if params[:name]
      scope.with_name(params[:name])
    elsif params[:text]
      scope.with_text(params[:text])
    end

    render json: @cards.map {|c| c.attributes.merge(editions: c.editions.as_json(methods: :image_crop_url)) }
  end
end
