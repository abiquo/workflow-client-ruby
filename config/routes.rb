Rails.application.routes.draw do
    mount Resque::Server, at: '/jobs'

    get '/task/:uuid/accept', to: 'tasks#accept', as: 'accept_task'
    get '/task/:uuid/cancel', to: 'tasks#cancel', as: 'cancel_task'
    get '/tasks/multiple', to: 'tasks#multiple'
    post '/callback', to: 'workflow#callback'
end
