Rails.application.routes.draw do
  devise_for :users, path: '/', path_names: { sign_in: 'signin',  sign_up: 'signup', sign_out: 'signout' }, controllers: { registrations: "users/registrations", sessions: 'users/sessions' }
  
  devise_scope :user do
    post '/signup',         to: 'users/registrations#create',  as: 'signup_create'
    post '/signin',         to: 'users/sessions#create',  as: 'signin_create'
  end

  devise_for :review_centers, path: 'reviewcenter', path_names: { sign_in: 'signin',  sign_up: 'signup', sign_out: 'signout' }, controllers: { sessions: 'review_centers/sessions', registrations: 'review_centers/registrations' }, only: [:sessions, :registrations, :passwords]

  devise_scope :review_center do
    post '/reviewcenter/signup',         to: 'review_centers/registrations#create',  as: 'rc_signup_create'
    post '/reviewcenter/signin',         to: 'review_centers/sessions#create',  as: 'rc_signin_create'
    get 'teachers' => 'rc_pages#teachers', as: 'rc_teachers'
  end

  authenticated :review_center do
    root to: 'rc_pages#home', as: 'authenticated_rc_root'
  end


  # PAYMENT API

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
  end

  # REVIEW CENTER PAGES
  scope '/reviewcenter' do
    get 'teachers' => 'rc_pages#teachers', as: 'teachers'
    get 'teachers/invitations' => 'rc_pages#teacher_invitations', as: 'rc_teachers_invitations'
  end
  
  # TEACHER PAGES
  scope '/teacher/:review_center_id', as: 'rc' do
    resources :lessons
  end

  scope '/teacher' do
    get '/home' => 'teachers#home', as: 'teacher_home'
    get '/invitations/new' => 'teachers#new_invitation', as: 'new_invitation'
    get '/search' => 'teachers#search'
    post '/invitations' => 'teachers#create_invitation', as: 'create_invitation'
    get '/invitations' => 'teachers#rc_invitations', as: 'invitations'
    post '/invitations/accept' => 'teachers#accept_invitation', as: 'accept_invitation'
    post '/invitations/reject' => 'teachers#reject_invitation', as: 'reject_invitation'
    delete '/invitations/:id' => 'teachers#delete_invitation', as: 'delete_invitation'
  end

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
