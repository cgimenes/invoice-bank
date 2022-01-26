Rails.application.routes.draw do
  resources :payments
  resources :invoices
  resources :transfers
  resources :companies
  post 'import/import'
  # root "articles#index"
end
