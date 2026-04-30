Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'

  namespace :api do
    namespace :v1 do
      post 'upload_image', to: 'uploads#create'
    end
  end
end
