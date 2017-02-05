Rails.application.routes.draw do
  scope '/api' do
    scope '/v1' do
      resources :users, only: %i(index create)
    end
  end
end
