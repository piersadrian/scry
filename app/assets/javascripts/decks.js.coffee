#= require lib/typeahead.min
#= require lib/hogan.min

$(document).ready ->
  $('#card-name').typeahead
    remote:
      url: "/cards/search?name=%QUERY&num=5"
      rateLimitWait: 200
      filter: (cards) ->
        for card in cards
          card.image_url = card.editions[ card.editions.length - 1 ].image_url
        return cards

    valueKey: "name"
    limit: 5
    engine: Hogan
    template: '
      <div class="card-suggestion group">
        <div class="card-image pull-left">
          <img src="{{image_url}}">
        </div>

        <div class="card-details pull-left">
          <header class="group">
            <h3 class="card-cost pull-right">{{ mana_cost }}</h3>
            <h3 class="card-name">{{ name }}</h3>
          </header>

          <footer class="group">
            <h3 class="card-stats pull-right">
              {{#power}}{{ power }} / {{ toughness }}{{/power}}
              {{#loyalty}}{{ loyalty }}{{/loyalty}}
            </h3>
            <h4 class="card-type">{{ card_type }} {{#subtype}} — {{ subtype }}{{/subtype}}</h4>
          </footer>
        </div>
      </div>'

  $('#card-name').on 'typeahead:selected', (event, card) ->
    console.log card
