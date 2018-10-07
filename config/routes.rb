require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                              ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web, at: '/sidekiq'

  root :to => "home#index"

  get "/signup", :to => "users#new", :as => :new_user
  post "/signup", :to => "users#create", :as => false
  get "/login", :to => "login#new"
  post "/login", :to => "login#create"
  get "/logout", :to => "login#destroy"
  get "/ranking", :to => "ranking#index"
  get "/events/ajax", :to => "events#ajax"

  resources :password_resets
  resources :users, only: [:show, :edit, :update]

  resources :talks do
    resources :external_events, only: [:new, :create, :edit, :update]
    resources :submit_events, only: [:new, :create]
    resources :watches, only: [:create]
  end

  resources :events do
    resources :schedules, only: [:new, :create, :edit, :update, :destroy] do
      resources :votes, only: [:create, :destroy]
      resource :was_presented, only: [:create]
    end
    resources :export_subscribers, only: [:new, :create]
    resources :presences, only: [:create]
    resources :enrollments, only: [:new, :create, :edit, :update]
  end

  resources :talk_info, only: [:create]
  resources :talk_search, only: [:index]
  resources :activities, only: [:create]
  resources :events_ajax, only: :index
  resources :talks_ajax, only: :index

  scope "/ratings/:rateable_type/:rateable_id" do
    post "/ratings", :to => "ratings#create", :as => :ratings
  end

  scope "/comments/:commentable_type/:commentable_id" do
    post   "/comments",     :to => "comments#create",  :as => :comments
    delete "/comments/:id", :to => "comments#destroy", :as => :comment
  end
end
