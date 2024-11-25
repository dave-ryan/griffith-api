Rails.application.routes.draw do
  defaults format: :json do
    put "/admin/reboot" => "admin#reboot"
    put "/admin/secret-santa-shuffle" => "admin#secret_santa_shuffle"
    put "/admin/gifts-cleanup" => "admin#gifts_cleanup"
    put "/generate-share-code" => "users#generate_share_code"
    put "/users/:id/friend" => "friendships#create"

    get "/admin/families" => "admin#families_index"
    get "/secret-santa" => "secret_santa#index"
    get "/current-user" => "users#show"
    get "/users/:id" => "users#share"
    get "/friends" => "friendships#index"

    post "/sessions" => "sessions#create"
    
    resources :customgifts, only: [:create, :update, :destroy]
    resources :gifts, only: [:index, :create, :update, :destroy]
    resources :users, only: [:index, :create, :update, :destroy]
    resources :families, only: [:index, :create, :update, :destroy]
  end
end
