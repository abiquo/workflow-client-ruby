class TasksController < ApplicationController
    protect_from_forgery with: :null_session

    def accept
        task = Task.find(params[:id])
        unless validate_task(task)
            @message = "Requested task ID is not valid!"
        else
            @message = "Your task is being processed. You will see progress in the Abiquo UI."
            AcceptTaskJob.perform_later([task])
        end
    end

    def cancel
        task = Task.find(params[:id])
        unless validate_task(task)
            @message = "Requested task ID is not valid!"
        else
            @message = "Your task is being processed. You will see progress in the Abiquo UI."
            CancelTaskJob.perform_later([task])
        end
    end

    def multiple
        task_ids = params[:tasks].split(',')
        tasks = Task.find(task_ids)
        case params[:task_action]
        when 'accept'
            AcceptTaskJob.perform_later(tasks)
        when 'cancel'
            CancelTaskJob.perform_later(tasks)
        end
        @message = "Your tasks are being processed. You will see progress in the Abiquo UI."
    end

    private 

    def validate_task(task)
        task.active?
    end
end
