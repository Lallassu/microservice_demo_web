Rails.application.routes.draw do
    post '/login', to: "game#login"
    get '/servers', to: "game#servers"
    get '/toplist', to: "game#toplist"
    root 'game#index'
end
