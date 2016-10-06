Rails.application.routes.draw do
    mount Resque::Server, at: '/jobs'

    get '/task/:id/accept', to: 'tasks#accept', as: 'accept_task'
    get '/task/:id/cancel', to: 'tasks#cancel', as: 'cancel_task'
    get '/tasks/multiple', to: 'tasks#multiple'
    post '/workflow/callback', to: 'workflow#callback'
end
