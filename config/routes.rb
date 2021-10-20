Rails.application.routes.draw do
  devise_for :users, path: '/', path_names: { sign_in: 'signin',  sign_up: 'signup', sign_out: 'signout' }, controllers: { registrations: "users/registrations", sessions: 'users/sessions' }
  
  devise_scope :user do
    post '/signup',         to: 'users/registrations#create',  as: 'signup_create'
    post '/signin',         to: 'users/sessions#create',  as: 'signin_create'
  end

  devise_for :review_centers, path: 'rc', path_names: { sign_in: 'signin',  sign_up: 'signup', sign_out: 'signout' }, controllers: { sessions: 'review_centers/sessions', registrations: 'review_centers/registrations' }, only: [:sessions, :registrations, :passwords]

  devise_scope :review_center do
    post '/rc/signup',         to: 'review_centers/registrations#create',  as: 'rc_signup_create'
    post '/rc/signin',         to: 'review_centers/sessions#create',  as: 'rc_signin_create'
  end

  authenticated :review_center do
    root to: 'rc_pages#home', as: 'authenticated_rc_root'
  end

  
  scope '/teacher/:review_center_id', as: 'rc' do
    resources :lessons
  end

  # PAYMENT API

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
  end
  
  #TEACHER PAGES
  get '/home' => 'teachers#home', as: 'teacher_home'
  get 'teachers/invitations/new' => 'teachers#new_invitation', as: 'new_invitation'
  get '/teachers/search' => 'teachers#search'
  post 'teachers/invitations' => 'teachers#create_invitation', as: 'create_invitation'

  # STUDENT PAGES

  get '/student/my_carts', to: 'user_carts#user_carts', as: 'user_carts'
  post '/student/add_to_cart/:lesson_id', to: 'user_carts#add_to_cart', as: 'add_to_cart'
  delete '/student/remove_to_cart/:user_cart_id', to: 'user_carts#remove_to_cart', as: 'remove_to_cart'
  get '/student/details/:lesson_id', to: 'courses#paid_lesson_access', as: 'paid_lesson_access'
  get '/student/my_lessons', to: 'courses#my_lessons', as: 'my_lessons'
  get '/student/my_transactions', to: 'transactions#student_transactions', as: 'my_transactions'

  # ADMIN PAGES
  get '/admin', to: 'admin#index', as: 'admin'

  # PUBLIC PAGES

  get '/course/:subject_title/:course_id/:lesson_id', to: 'courses#lesson_details', as: 'lesson_details'
  root 'public_pages#landing'

end
