require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                              ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
end if Rails.env.production?

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web, at: '/sidekiq'

  root to: 'home#index'

  get '/signup', to: 'users#new', as: :new_user
  post '/signup', to: 'users#create', as: false
  get '/login', to: 'login#new'
  post '/login', to: 'login#create'
  get '/logout', to: 'login#destroy'
  get '/ranking', to: 'ranking#index'

  resources :password_resets
  resources :users, only: %i[show edit update]

  resources :talks do
    resources :external_events, only: %i[new create edit update]
    resources :submit_events, only: %i[new create]
    resources :watches, only: %i[create]
  end

  resources :events do
    resources :schedules, only: %i[new create edit update destroy] do
      resources :votes, only: %i[create destroy]
      resource :was_presented, only: %i[create]
    end
    resources :export_subscribers, only: %i[new create]
    resources :presences, only: %i[create]
    resources :enrollments, only: %i[new create edit update], path: ':option_type'
  end

  resources :talk_info, only: %i[create]
  resources :talk_search, only: %i[create]

  scope '/ratings/:rateable_type/:rateable_id' do
    post '/ratings', to: 'ratings#create', as: :ratings
  end

  scope '/comments/:commentable_type/:commentable_id' do
    post   '/comments',     to: 'comments#create',  as: :comments
    delete '/comments/:id', to: 'comments#destroy', as: :comment
  end
end
