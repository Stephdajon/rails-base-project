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
    get '/:rc_course_id' =>  'rc_pages#rc_course', as: 'rc_course'
    get '/:rc_course_id/subject/:subject_id' =>  'rc_pages#rc_subject', as: 'rc_subject'
    get '/:rc_course_id/subject/:subject_id/lesson/:lesson_id' =>  'rc_pages#rc_lesson', as: 'rc_lesson'
    get '/rccourses/new' =>  'rc_courses#new', as: 'new_rc_course'
    post '/rccourses' =>  'rc_courses#create', as: 'create_rc_course'
  end

  scope 'rcteacher/:id' do
    get '/subjects/new' => 'teacher_subjects#new', as: 'new_teacher_subject'
    post '/subjects' => 'teacher_subjects#create', as: 'create_teacher_subject'
  end
  
  # TEACHER PAGES

  scope '/teacher/:review_center_id', as: 'rc_teacher' do
    resources :lessons
  end

  scope '/teacher' do
    get '/home' => 'teachers#home', as: 'teacher_home'
    get '/invitations/new' => 'teachers#new_invitation', as: 'new_invitation'
    get '/search' => 'teachers#search'
    post '/invitations' => 'teachers#create_invitation', as: 'create_invitation'
    get '/invitations' => 'teachers#rc_invitations', as: 'invitations'
    patch '/invitations/accept/:id' => 'teachers#accept_invitation', as: 'accept_invitation'
    patch '/invitations/reject/:id' => 'teachers#reject_invitation', as: 'reject_invitation'
    patch '/invitations/resend/:id' => 'teachers#resend_invitation', as: 'resend_invitation'
    delete '/invitations/:id' => 'teachers#delete_invitation', as: 'delete_invitation'
  end

  # STUDENT PAGES

  scope '/student' do
    get '/my_carts', to: 'user_carts#user_carts', as: 'user_carts'
    post '/add_to_cart/:lesson_id', to: 'user_carts#add_to_cart', as: 'add_to_cart'
    delete '/remove_to_cart/:user_cart_id', to: 'user_carts#remove_to_cart', as: 'remove_to_cart'
    get '/details/:lesson_id', to: 'courses#paid_lesson_access', as: 'paid_lesson_access'
    get '/my_lessons', to: 'courses#my_lessons', as: 'my_lessons'
    get '/my_transactions', to: 'transactions#student_transactions', as: 'my_transactions'
    get '/:lesson_id/review/new', to: 'reviews#new', as: 'new_review'
    post '/:lesson_id/review/new', to: 'reviews#create', as: 'create_review'
    get '/:lesson_id/reviews/', to: 'reviews#index', as: 'reviews'
  end

  # ADMIN PAGES

  scope '/' do
  get '', to: 'admin#index', as: 'admin'
  get '/user_list/:id', to: 'admin#user_details', as: 'admin_user_details'
  get '/user_list/teacher/:id', to: 'admin#teacher_details', as: 'admin_teacher_details'
  get '/review_center_list/:id', to: 'admin#rc_details', as: 'admin_rc_details'
  get '/users_list', to: 'admin#users_list', as: 'admin_users_list'
  get '/review_centers', to: 'admin#review_centers', as: 'admin_review_centers'
  patch '/approved_user/:id', to: 'admin#approve_users', as: 'approve_users'
  patch '/approve_rc/:id', to: 'admin#approve_rc', as: 'approve_rc'
  get '/transactions', to: 'admin#transactions', as: 'admin_transactions'
  end
  
  # PUBLIC PAGES

  get '/course/:subject_title/:course_id/:lesson_id', to: 'courses#lesson_details', as: 'lesson_details'
  root 'public_pages#landing'

end
