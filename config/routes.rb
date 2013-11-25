Mtg::Application.routes.draw do
  resources :decks
  resources :cards do
    get 'search', action: :search, on: :collection
  end
end
