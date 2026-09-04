Rails.application.routes.draw do
  root "dashboard#show"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  namespace :admin do
    get "dashboard", to: "dashboard#show"
    resources :students
    resources :teachers
    resources :courses
    resources :classrooms
    resources :enrollments, only: %i[index create update destroy]
    resources :schedules
    resources :student_progresses, path: "progress"
  end

  namespace :teacher do
    get "dashboard", to: "dashboard#show"
    resources :classes, only: %i[index show], controller: "classes"
    resources :students, only: %i[index show]
    resources :schedules, only: :index
    resources :student_progresses, path: "progress", only: %i[index show new create edit update]
  end

  namespace :student do
    get "dashboard", to: "dashboard#show"
    resources :classes, only: %i[index show], controller: "classes"
    resources :schedules, only: :index
    resources :progress, only: %i[index show], controller: "progress"
    resource :profile, only: %i[show edit update], controller: "profiles"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
