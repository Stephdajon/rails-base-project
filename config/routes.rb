Rails.application.routes.draw do
  devise_for :users
  
  devise_for :review_centers, 
  path: 'rc',
  controllers: {
    sessions: 'review_centers/sessions',
    registrations: 'review_centers/registrations'
  }

  authenticated :review_center do
    root to: 'rc_pages#home', as: 'authenticated_rc_root'
  end
  

  # STUDENT PAGES

  get '/student/my_carts', to: 'user_carts#user_carts', as: 'user_carts'
  post '/student/add_to_cart/:lesson_id', to: 'user_carts#add_to_cart', as: 'add_to_cart'
  delete '/student/remove_to_cart/:user_cart_id', to: 'user_carts#remove_to_cart', as: 'remove_to_cart'

  # PUBLIC PAGES

  get '/course/:subject_title/:course_id/:lesson_id', to: 'courses#lesson_details', as: 'lesson_details'
  root 'public_pages#landing'

end
