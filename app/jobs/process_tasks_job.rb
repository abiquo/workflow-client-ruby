class ProcessTasksJob < ApplicationJob
    queue_as :pending_tasks

    def perform(tasks)
        log = Rails.logger
        
        task_details = AbiquoAPIHelpers.retrieve_tasks_details(tasks)

        # Retrieve email notification list
        log.info "Retrieving approval emails..."
        abq = AbiquoAPI.new($abiquo_config)
        ent_lnk = AbiquoAPI::Link.new href: 'admin/enterprises',
                                      type: 'application/vnd.abiquo.enterprises+json',
                                      client: abq
        abq_enterprise = ent_lnk.get.select {|e| e.name == task_details[:enterprise] }.first
        approval_users = abq_enterprise.link(:users).get.select {|u| u.link(:role).title == APP_CONFIG['approval_role'] }
        approval_emails = approval_users.map {|u| u.email }

        log.debug "Task details are #{task_details.inspect}"
        log.debug "Approval emails are #{approval_emails.inspect}"

        # Handle empty notification address
        if approval_emails.count == 0
            log.info "No approval emails found, taking default action #{APP_CONFIG['default_action']}"
            case APP_CONFIG['default_action']
            when 'ACCEPT'
                AcceptTaskJob.perform_later(tasks)
            when 'CANCEL'
                CancelTaskJob.perform_later(tasks)
            end
        else
            # Queue the Mailer
            TasksMailer.send_approval_email(task_details, approval_emails).deliver_later
        end
    end
end