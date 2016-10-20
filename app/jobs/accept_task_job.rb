class AcceptTaskJob < ApplicationJob
    queue_as :accept

    def perform(tasks)
        log = Rails.logger

        task_details = AbiquoAPIHelpers.retrieve_tasks_details(tasks)

        log.info "Connecting to Abiquo API..."
        abq = AbiquoAPI.new($abiquo_config)

        tasks.each do |task|
            begin
                log.info "Accepting task at '#{task.continue_url}'"
                task_lnk = AbiquoAPI::Link.new(href: JSON.parse(task.continue_url)['href'], type: '*/*')
                abq.post(task_lnk, {})
                task.active = false
                task.save
                log.info "Task accepted successfully."
            rescue Exception => e
                log.error "Error ocurred accepting task:"
                log.error e.message
                log.debug e.backtrace
                exit 1
            end
        end
        task_details[:vm_details].map {|v| v[:task_action] = 'ACCEPTED' }

        # Mail to user
        user_lnk = AbiquoAPI::Link.new href: JSON.parse(tasks.first.user_url)['href'],
                                       type: 'application/vnd.abiquo.user+json',
                                       client: abq
        user_email = user_lnk.get.email
        unless user_email.empty?
            TasksMailer.send_requester_email(task_details, user_email).deliver_later
        else
            log.info "Not sending email to requester user as it has no email set in Abiquo."
        end
    end
end
