Rails.application.routes.draw do
  root 'logins#new'
  get 'root/index'
  resource  :login, only: %i{show create destroy}
  resources :user
  resources :document
  get 'document/:id/download' => 'document#download'
  resources :tag
end
