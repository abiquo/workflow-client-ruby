class WorkflowController < ApplicationController
    protect_from_forgery with: :null_session

    def callback
        tasks = Task.from_json(request.body.read)
        ProcessTasksJob.perform_later(tasks)
    end
end
